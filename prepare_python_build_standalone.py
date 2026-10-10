import argparse
import shutil
import os
import pathlib
import sys
import zipfile

from typing import Optional

# ref. emscripten/wasm_assets.py
# note that site data vars are already portable
PYZIPFILE_IGNORE_NAMES = (
    "lib-dynload",  # platform specific libraries
    "site-packages",  # standalone builds ship w/ pip
    "ensurepip",  # strip builtin getter as well
    "turtledemo",
)

UNUSED_DIRS = (
    "include",  # development headers
    "share",  # manpages
)

PTH_TAIL = (
    "",
    "# Uncomment to run site.main() automatically",
    "#import site",
    "",
)

STDLIB_DIR = f"python{sys.version_info.major}.{sys.version_info.minor}"
STDLIB_ZIP = f"python{sys.version_info.major}{sys.version_info.minor}.zip"


class Windows:
    @staticmethod
    def probe(p: pathlib.Path) -> bool:
        return (p / "python.exe").exists() or (p / "Lib").exists()

    def __init__(self, root: pathlib.Path):
        self.root = root

    def __repr__(self):
        return f"Windows<{self.root}>"

    @property
    def entrypoint(self) -> pathlib.Path:
        return self.root / "python.exe"

    @property
    def stdlib_dir(self) -> pathlib.Path:
        return self.root / "Lib"

    @property
    def stdlib_zip(self) -> pathlib.Path:
        return self.root / STDLIB_ZIP

    # windows named either w/o version OR w/ dot-less version (same as .zip)
    @property
    def pth_file(self) -> pathlib.Path:
        return (
            self.root / f"python{sys.version_info.major}{sys.version_info.minor}._pth"
        )

    @property
    def pth_contents(self) -> str:
        out = []
        out.append(f"./{self.stdlib_zip}")
        out.append("./DLLs")
        out.append(".")
        out.extend(PTH_TAIL)
        return "\n".join(out)


class Generic:
    def __init__(self, root: pathlib.Path):
        self.root = root

    def __repr__(self):
        return f"Generic<{self.root}>"

    @property
    def entrypoint(self) -> pathlib.Path:
        return self.root / "python3"

    @property
    def bindir(self) -> pathlib.Path:
        return self.root / "bin"

    @property
    def bindir_entrypoint(self) -> pathlib.Path:
        return self.bindir / "python3"

    @property
    def libdir(self) -> pathlib.Path:
        return self.root / "lib"

    @property
    def stdlib_dir(self) -> pathlib.Path:
        return self.libdir / STDLIB_DIR

    @property
    def stdlib_zip(self) -> pathlib.Path:
        return self.libdir / STDLIB_ZIP

    # ref. getpath.py, and make sure its name matches python MAJOR DOT MINOR
    # "adjacent to the main DLL/dylib/so (if set) OR adjacent to the original executable"
    @property
    def pth_file(self) -> pathlib.Path:
        return (
            self.bindir
            / f"python{sys.version_info.major}.{sys.version_info.minor}._pth"
        )

    @property
    def pth_contents(self) -> str:
        out = []
        out.append(f"../lib/{self.stdlib_zip.name}")
        out.append(f"../lib/python{sys.version_info.major}.{sys.version_info.minor}")
        out.extend(PTH_TAIL)
        return "\n".join(out)


def remove_path(p: pathlib.Path):
    if p.is_dir(follow_symlinks=False):
        shutil.rmtree(p, ignore_errors=True)
    else:
        p.unlink(missing_ok=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Repackaging standard library into .zip")
    parser.add_argument("--bootstrap", action="store_true")
    parser.add_argument("root", type=pathlib.Path)
    args = parser.parse_args()

    root: pathlib.Path = args.root.resolve()
    if not root.exists():
        raise ValueError(f"{root} does not exist")

    if not root.is_dir():
        raise ValueError(f"{root} not a dir")

    handler = Windows(root) if Windows.probe(root) else Generic(root)
    print(f"Starting {handler}")

    stdlib_zip = handler.stdlib_zip
    if handler.stdlib_dir.exists():
        if stdlib_zip.exists():
            print(f"Remove existing {stdlib_zip}")
            stdlib_zip.unlink()

        ignore_paths = {
            (handler.stdlib_dir / name).resolve() for name in PYZIPFILE_IGNORE_NAMES
        }

        def filterfunc(s: str) -> bool:
            p = pathlib.Path(s).resolve()
            return p not in ignore_paths

        pending_removal: list[pathlib.Path] = []

        with zipfile.PyZipFile(
            stdlib_zip, mode="w", compression=zipfile.ZIP_DEFLATED
        ) as zip_archive:
            if zip_archive.compresslevel is not None:
                zip_archive.compresslevel = 9
            for p in sorted(handler.stdlib_dir.iterdir()):
                p = p.resolve()

                # keep in the search path for Generic
                if p.name == "lib-dynload":
                    continue

                # .zip contains .pyc
                if p.name == "__pycache__":
                    pending_removal.append(p)
                    continue

                # process everything else and prune afterwards
                if p.is_dir() or p.suffix == ".py":
                    zip_archive.writepy(p, filterfunc=filterfunc)
                    pending_removal.append(p)

        print(f"Prepared {stdlib_zip}")

        for p in pending_removal:
            remove_path(p)

        if len(list(handler.stdlib_dir.iterdir())) == 0:
            print(f"Removing empty directory {p}")
            remove_path(handler.stdlib_dir)

    unused_paths = {(root / name).resolve() for name in UNUSED_DIRS}
    for p in unused_paths:
        print(f"Removing unused directory {p}")
        remove_path(p)

    print(f"Site override {handler.pth_file}")
    handler.pth_file.write_text(handler.pth_contents)

    bindir_entrypoint: Optional[pathlib.Path] = getattr(
        handler, "bindir_entrypoint", None
    )
    if bindir_entrypoint:
        print(f"Entrypoint ${root}/python3")
        handler.entrypoint.symlink_to(bindir_entrypoint.relative_to(root))
