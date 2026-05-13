# sequential-image-analyzer

Bash script for sequential analysis of NIfTI images with ITK-SNAP. This script waits for ITK-SNAP to close before opening the next image, allowing a manual inspection.

### How to install and use

To install, clone this repository and run this command:

```sh
git clone
cd sequential-image-analyzer
make install  # Install to /usr/local/bin by default.
```

This software allows this **flags**:
- `--images-dir PATH`: required, parent directory with the subdirectories containing NIfTI images.
- `--start-id NAME`: optional, skip subdirectories until one with basename NAME is found, then start processing.
- `--first-one`: optional, open only the frist matching image in each subdirectory.
- `--help, -h`: show help.

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

Each immediate subdirectory represents a single subject or session; the script treats each subdirectory as a unit and opens the NIfTI files it contains before moving to the next subdirectory. Files are processed in a single alphabetical order (mixing .nii and .nii.gz), files located directly in the parent directory are ignored, and the script does not recurse into nested folders.

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

- **Bash (GNU Bash)**: run with bash or ensure shebang `#1/usr/bin/env bash` is used.
- **ITK-SNAP**: must be available in `PATH` or accessible via a wrapper/symlink.
- **make**: required to use the provided Makefile targets.
