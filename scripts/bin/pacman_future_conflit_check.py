"""The following command checks which packages have a dependency on a given package checking through
all packages even though not installed locally:
pacman -Sii nodejs-lts-gallium | grep "Req" | sed -e 's/Required By    : //g'

This returns a string of packages separated by spaces and some prefix.

This script does the same thing but then in python and tells you which packages you currently have 
installed of those. This is inspired by getting "warning: removing 'nodejs' from target list because
it conflicts with 'nodejs-lts-gallium'" why trying to run pacman -Syu today.
The warning does not help, it should tell me where the warning is coming from.
"""

import sys
import subprocess
from typing import List


def run(cmd: str, timeout=None) -> subprocess.CompletedProcess:
    return subprocess.run(cmd,
                          shell=True,
                          stderr=subprocess.PIPE,
                          stdout=subprocess.PIPE,
                          universal_newlines=True,
                          timeout=timeout)


def query_required_by_for_package(package_name: str) -> List[str]:
    """Returns list of 'Required By'-packages for which given package"""

    cmd = f'pacman -Sii {package_name} | grep "Required By" | tr -s \' \' | sed -e \'s/Required By : //g\''
    res = run(cmd)
    packages: list = res.stdout.strip().split(' ')
    return packages


def pacman_Qq() -> List[str]:
    """Returns all installed packages"""

    cmd = 'pacman -Qq'
    res = run(cmd)
    packages: list = res.stdout.strip().split('\n')
    return packages


def pacman_Sii_depends_on(package: str) -> List[str]:
    """Returns 'Depends On'-packages based on package info from the database, so not based on 
    currently installed package so potentially there can be a difference, for instance when in the 
    next version a depends on is added/changed than this is only reflected by -Sii instead of -Qi 
    which looks only at currently installed. This also helps because it does not require you to have 
    the package already installed because it looks in the pacman database."""

    cmd = f'pacman -Sii {package} | grep "Depends On" | tr -s \' \' | sed -e \'s/Depends On : //g\''
    res = run(cmd)
    packages: list = res.stdout.strip().split(' ')
    return packages


def find_out(package_name: str):
    packages = query_required_by_for_package(given_package)
    # print(packages)

    installed_packages = pacman_Qq()
    # print(installed_packages)

    # intersection of installed packages and required-by-packages-for-given-package
    intersection = set(packages).intersection(installed_packages)

    true_candidates = []

    for candidate_pkg in intersection:
        candidate_depends_on_pkgs = pacman_Sii_depends_on(candidate_pkg)
        if candidate_depends_on_pkgs:
            if given_package in candidate_depends_on_pkgs:
                true_candidates.append(candidate_pkg)

    print(
        f'for given package {given_package} these packages are currently installed for which (future or currently installed) versions depend on this package:'
    )
    for true_candidate in true_candidates:
        print(true_candidate)


if __name__ == "__main__":
    try:
        given_package = sys.argv[1]
    except IndexError:
        print(f'usage: python3 {__file__} <package_name>')
        sys.exit(1)

    find_out(given_package)
    sys.exit(0)
