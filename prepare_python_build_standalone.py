import argparse
import shutil
import os
import pathlib
import sys
import zipfile

from typing import Optional

# ref. emscripten/wasm_assets.py
# note that site data vars are already portable
IGNORE_NAMES = (
    "lib-dynload",  # dynamic libs, currently unused
    "site-packages",  # standalone builds ship w/ pip
    "ensurepip",  # strip builtin getter as well
    "turtledemo",
    "__pycache__",
)

OUTPUT_ZIP_NAME = f"python{sys.version_info.major}{sys.version_info.minor}.zip"
OUTPUT_PTH_NAME = f"python{sys.version_info.major}{sys.version_info.minor}._pth"
OUTPUT_PTH_LINES = (
    OUTPUT_ZIP_NAME,
    ".",
    "",
    "# Uncomment to run site.main() automatically",
    "#import site",
    "",
)

LIB_DIR_NAME = f"python{sys.version_info.major}.{sys.version_info.minor}"


class Windows:
    @staticmethod
    def probe(p: pathlib.Path) -> bool:
        return (p / "python.exe").exists() or (p / "Lib").exists()

    def __init__(self, root: pathlib.Path):
        self.root = root

    @property
    def entrypoint(self) -> pathlib.Path:
        return self.root / "python.exe"

    @property
    def stdlib_dir(self) -> pathlib.Path:
        return self.root / "Lib"

    @property
    def output_zip(self) -> pathlib.Path:
        return self.root / OUTPUT_ZIP_NAME

    @property
    def output_pth(self) -> pathlib.Path:
        return self.root / OUTPUT_PTH_NAME

    @property
    def output_pth_contents(self) -> str:
        out = list(OUTPUT_PTH_LINES)
        out.insert(1, "DLLs")
        return "\n".join(out)

    @property
    def prune(self):
        return [
            self.root / "Lib",
            self.root / "include",
        ]


class Generic:
    def __init__(self, root: pathlib.Path):
        self.root = root

    @property
    def entrypoint(self) -> pathlib.Path:
        return self.root / "python3"

    @property
    def bindir_entrypoint(self) -> pathlib.Path:
        return self.root / "bin" / "python3"

    @property
    def stdlib_dir(self) -> pathlib.Path:
        return self.root / "lib" / LIB_DIR_NAME

    @property
    def output_zip(self) -> pathlib.Path:
        return self.root / "lib" / OUTPUT_ZIP_NAME

    @property
    def output_pth(self) -> pathlib.Path:
        return self.root / "lib" / OUTPUT_PTH_NAME

    @property
    def output_pth_contents(self) -> str:
        return "\n".join(OUTPUT_PTH_LINES)

    @property
    def prune(self):
        return [
            self.root / "lib" / LIB_DIR_NAME,
            self.root / "share",
            self.root / "include",
        ]


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Repackaging standard library into .zip")
    parser.add_argument("--bootstrap", action="store_true")
    parser.add_argument("root", type=pathlib.Path)
    args = parser.parse_args()

    root: pathlib.Path = args.root
    if not root.exists():
        raise ValueError(f"{root} does not exist")

    if not root.is_dir():
        raise ValueError(f"{root} not a dir")

    handler = Windows(root) if Windows.probe(root) else Generic(root)
    output_zip = handler.output_zip

    if handler.stdlib_dir.exists():
        if output_zip.exists():
            print(f"Remove existing {output_zip}")
            output_zip.unlink()

        ignore_paths = {(handler.stdlib_dir / name).resolve() for name in IGNORE_NAMES}

        def filterfunc(s: str) -> bool:
            p = pathlib.Path(s).resolve()
            return p not in ignore_paths

        with zipfile.PyZipFile(
            output_zip, mode="w", compression=zipfile.ZIP_DEFLATED
        ) as zip_archive:
            if zip_archive.compresslevel is not None:
                zip_archive.compresslevel = 9
            for p in sorted(handler.stdlib_dir.iterdir()):
                p = p.resolve()
                if p.name == "__pycache__":
                    continue

                if p.is_dir() or p.suffix == ".py":
                    zip_archive.writepy(p, filterfunc=filterfunc)

        print(f"Packaged {output_zip}")

    for p in handler.prune:
        print(f"Removing {p}")
        if p.is_dir(follow_symlinks=False)
            shutil.rmtree(p, ignore_errors=True)
        else:
            p.unlink(missing_ok=True)

    print(f"Site override {handler.output_pth}")
    handler.output_pth.write_text(handler.output_pth_contents)

    bindir_entrypoint: Optional[pathlib.Path] = getattr(
        handler, "bindir_entrypoint", None
    )
    if bindir_entrypoint:
        print(f"Entrypoint ${root}/python3")
        handler.entrypoint.symlink_to(bindir_entrypoint.relative_to(root))
