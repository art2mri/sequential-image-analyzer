# sequential-image-analyzer

A lightweight Bash utility for manual image inspection: it scans immediate subdirectories, open each NIfTI image in ITK-SNAP, and blocks until the viewer closes so you can review images one-by-one.

### Installation

To install, clone this repository and install the script to your system `bin`:

```sh
git clone https://github.com/art2mri/sequential-image-analyzer.git
cp sequential-image-analyzer
sudo make install  # Installs bin/sequential-image-analyzer to /usr/loca/bin by default.
```

#### Command line flags

- `--images-dir PATH`: required, parent directory with the subdirectories containing NIfTI images.
- `--start-id NAME`: optional, skip subdirectories until one with basename NAME is found, then start processing.
- `--first-one`: optional, open only the frist matching image in each subdirectory.
- `--help, -h`: show usage.

#### How to verify the installation

You can check if this software was installed correctly with this command:

```sh
make verify
```

Also, run the help to confirm the script executes:

```sh
sequential-image-analyzer --help
```

#### How to uninstall

Just run `make uninstall` to remove the installed binary.

### Examples

```sh
# open all images under /data/PPMI
sequential-image-analyzer --images-dir /data/PPMI

# start at a specific subdirectory
sequential-image-analyzer --images-dir /data/PPMI --start-id subject_042

# open only the first image in each subdirectory
sequential-image-analyzer --images-dir /data/PPMI --first-one
```

### How to structure the parent directory

Each immediate subdirectory represents a single subject or session; the script treats each subdirectory as a unit and opens the NIfTI files it contains before moving to the next subdirectory.

Use this example to structure your parent directory:

```
PPMI/
├── subject_001/
│   ├── t1.nii.gz
│   └── t2.nii
├── subject_002/
│   └── t1.nii.gz
└── subject_003/
    ├── t1.nii
    └── flair.nii.gz
```

This software processes `subject_001`, `subject_002`, `subject_003` in alphabetical order and opens files inside each in alphabetical order.

### Dependencies

- **sudo**: required to install the package.
- **bash (GNU Bash)**: run with bash or ensure shebang `#1/usr/bin/env bash` is used.
- **make**: required to use the provided Makefile targets.
- **ITK-SNAP**: must be available in `PATH` or accessible via a wrapper/symlink.
