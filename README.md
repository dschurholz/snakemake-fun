# Snakemake Fun

Install conda environment:

```bash
$ conda env create -f requirements.yml
$ conda activate snakemake_fun
```

Create raw data:

```bash
$ python create_raw_data.py 10
```
Output:

```bash
data/
└── raw
    ├── file_001.txt
    ├── file_002.txt
    ├── file_003.txt
    ├── file_004.txt
    ├── file_005.txt
    ├── file_006.txt
    ├── file_007.txt
    ├── file_008.txt
    ├── file_009.txt
    └── file_010.txt
```

Run snakemake rules:

```bash
$ snakemake --cores 1
```

Output:

```bash
data/
├── interim
│   ├── worked_001.txt
│   ├── worked_002.txt
│   ├── worked_003.txt
│   ├── worked_004.txt
│   ├── worked_005.txt
│   ├── worked_006.txt
│   ├── worked_007.txt
│   ├── worked_008.txt
│   ├── worked_009.txt
│   └── worked_010.txt
├── processed
│   ├── final_001.txt
│   ├── final_002.txt
│   ├── final_003.txt
│   ├── final_004.txt
│   ├── final_005.txt
│   ├── final_006.txt
│   ├── final_007.txt
│   ├── final_008.txt
│   ├── final_009.txt
│   └── final_010.txt
└── raw
    ├── file_001.txt
    ├── file_002.txt
    ├── file_003.txt
    ├── file_004.txt
    ├── file_005.txt
    ├── file_006.txt
    ├── file_007.txt
    ├── file_008.txt
    ├── file_009.txt
    └── file_010.txt
```
