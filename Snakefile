import click
from glob import glob
from pathlib import Path
from parse import parse


def filtered_expand(input_dir,
                    input_path,
                    output_dir,
                    output_path,
                    initial_dir,
                    initial_path,
                    consider_wildcards=None,
                    return_outputs=False,
                    rule_name=None,
                    verbose=False):
    input_dir = Path(input_dir)
    output_dir = Path(output_dir)
    initial_dir = Path(initial_dir)
    input_files = sorted(glob(str(input_dir / '*')))
    output_files = sorted(glob(str(output_dir / '*')))
    final_files_list = []

    for in_f in sorted(glob(str(initial_dir / '*'))):
        parsed_in_f = parse(str(initial_dir / initial_path), in_f)
        if parsed_in_f is None:
            continue
        else:
            if return_outputs:
                final_files_list.append(
                    str(output_dir / output_path.format(**parsed_in_f.named)))
            else:
                final_files_list.append(
                    str(input_dir / input_path.format(**parsed_in_f.named))
                )
    for in_f in input_files:
        parsed_in_f = parse(str(input_dir / input_path), in_f)
        if parsed_in_f is None:
            continue

        for out_f in output_files:
            parsed_out_f = parse(str(output_dir / output_path), out_f)
            if parsed_out_f is None:
                continue

            for cw in consider_wildcards:
                if parsed_in_f[cw] != parsed_out_f[cw]:
                    break
            else:
                _file = (in_f if not return_outputs else
                         output_dir / output_path.format(**parsed_in_f.named))
                final_files_list.remove(str(_file))
                break
    if verbose:
        if rule_name is not None:
            click.secho(
                f"Rule {rule_name} "
                f"{('INPUT' if not return_outputs else 'OUTPUT')}",
                fg='cyan')
        click.secho(final_files_list, fg='yellow')
    return final_files_list


rule all:
    input:
         filtered_expand("data/raw/",
                         "file_{num}.txt",
                         "data/processed/",
                         "final_{num}.txt",
                         initial_dir="data/raw/",
                         initial_path="file_{num}.txt",
                         consider_wildcards=['num'],
                         return_outputs=True,
                         rule_name='All')


rule rule_A:
    input:
         filtered_expand("data/raw/",
                         "file_{num}.txt",
                         "data/interim/",
                         "worked_{num}.txt",
                         initial_dir="data/raw/",
                         initial_path="file_{num}.txt",
                         consider_wildcards=['num'],
                         rule_name='A')
    output:
         filtered_expand("data/raw/",
                         "file_{num}.txt",
                         "data/interim/",
                         "worked_{num}.txt",
                         initial_dir="data/raw/",
                         initial_path="file_{num}.txt",
                         consider_wildcards=['num'],
                         return_outputs=True,
                         rule_name='A')
    run:
        for o in output:
            shell(f"touch {o}")


rule rule_B:
    input:
         filtered_expand("data/interim/",
                         "worked_{num}.txt",
                         "data/processed/",
                         "final_{num}.txt",
                         initial_dir="data/raw/",
                         initial_path="file_{num}.txt",
                         consider_wildcards=['num'],
                         rule_name='B')
    output:
         filtered_expand("data/raw/",
                         "file_{num}.txt",
                         "data/processed/",
                         "final_{num}.txt",
                         initial_dir="data/raw/",
                         initial_path="file_{num}.txt",
                         consider_wildcards=['num'],
                         return_outputs=True,
                         rule_name='B')
    run:
        for o in output:
            shell(f"touch {o}")
