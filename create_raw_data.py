import sys
import click
from pathlib import Path
from snakemake.io import IOFile


class DummyRule:
    name = 'dummy'
    lineno = 0
    snakefile = 'Snakefile'


if __name__ == "__main__":
    num_files = eval(sys.argv[1])
    for i in range(1, num_files + 1):
        _file = f"data/raw/file_{i:03d}.txt"
        if not Path(_file).exists():
            click.secho(f"Creating {_file}", fg="green")
            iof = IOFile(_file, rule=DummyRule())
            iof.touch_or_create()
        else:
            click.secho(f"Skipping {_file}", fg="yellow")
