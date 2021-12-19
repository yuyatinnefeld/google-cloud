#!/usr/bin/env python
# source: https://towardsdatascience.com/setup-version-increment-and-automated-release-process-591d87ea1221
import os
import re

import fire

version_filepath = os.path.join('.', 'VERSION')
version_pattern = re.compile(fr'^\d+.\d+.\d+$')


def current():
    """
    reads the content of the version file
    
    Returns:
        current version number
    """
    with open(version_filepath, 'r') as version_file:
        version_lines = version_file.readlines()
        assert len(version_lines) == 1, 'Version file is malformed'
        version = version_lines[0]
        assert version_pattern.match(version), 'Version string is malformed'
        
        return version


def _overwrite_version_file(major: int, minor: int, patch: int) -> None:
    """
    overwrites the version in the version file
    
    Args:
        major: new major version
        minor: new minor version
        patch: new patch version

    Returns:
        None
    """
    print("old version: ", current())
    version = f'{major}.{minor}.{patch}'
    print("new version: ", version)
    with open(version_filepath, 'w') as version_file:
        version_file.write(version)


def inc_hotfix() -> None:
    """
    increments the current patch version, e.g. from 1.0.1 to 1.0.2
    
    Returns:
        None
    """
    version = current()
    major, minor, patch = version.split('.')
    _overwrite_version_file(major, minor, int(patch) + 1)


def inc_minor() -> None:
    """
    increments the current minor version, e.g. from 1.0.1 to 1.1.0
    
    Returns:
        None
    """
    version = current()
    major, minor, patch = version.split('.')
    _overwrite_version_file(major, int(minor) + 1, 0)


def inc_major() -> None:
    """
    increments the current major version, e.g. from 1.0.1 to 2.0.0

    Returns:
        None
    """
    version = current()
    major, minor, patch = version.split('.')
    _overwrite_version_file(int(major) + 1, 0, 0)


if __name__ == "__main__":
    fire.Fire({
        'current': current,
        'inc_fix': inc_hotfix,
        'inc_minor': inc_minor,
        'inc_major': inc_major
    })
