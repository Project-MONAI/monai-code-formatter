import os
import re
import sys
from collections import defaultdict

from mypy import api

MYPY_MSG = 'error: Unused "type: ignore" comment'
IGNORE_RE = re.compile(r"\s*#\s*type:\s*ignore.*$", re.I)


def run(cfg, codebase):
    print(f"mypy {cfg} {codebase}")
    if not os.path.exists(cfg):
        raise ValueError(f"{cfg} not found")
    if not os.path.exists(codebase):
        raise ValueError(f"{codebase} not found")
    stdout, stderr, exit_code = api.run(
        ["--config-file", f"{cfg}", "--warn-unused-ignores", f"{codebase}"]
    )

    if stderr:
        raise TypeError(f"mypy error: {stderr}")
    print(stdout)

    file_line_map = defaultdict(list)
    for line in stdout.split("\n"):
        if MYPY_MSG not in line:
            continue
        file_path, line_num, *_ = line.split(":")
        file_line_map[file_path].append(int(line_num))

    for file_path, lines_nums in file_line_map.items():
        print(f"Rewriting {file_path}")
        file = open(file_path, "r+")
        text = file.readlines()
        file.seek(0)  # rewind file pointer back to start of file

        for line_idx in lines_nums:
            text[line_idx - 1] = IGNORE_RE.sub("", text[line_idx - 1])
        file.writelines(text)
        file.truncate()
        file.close()


if __name__ == "__main__":
    cfg, codebase = sys.argv[1], sys.argv[2]
    run(cfg, codebase)
