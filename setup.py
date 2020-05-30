'''
Create the pypi package.
'''

import os
import subprocess
from setuptools import setup

with open("README.md", "r") as fh:
    LONG_DESCRIPTION = fh.read()

VERSION = os.environ.get('CI_COMMIT_TAG', '')

AUTHOR = subprocess.check_output(['git', 'config', 'user.name'])
EMAIL = subprocess.check_output(['git', 'config', 'user.email'])

setup(
    name='makefile2dot',
    version=VERSION,
    author=AUTHOR,
    author_email=EMAIL,
    description='Create a graphviz graph of a Makefile.',
    long_description=LONG_DESCRIPTION,
    long_description_content_type="text/markdown",
    packages=["makefile2dot"],
    scripts=["scripts/makefile2dot"],
    install_requires=[
        'graphviz',
        ],
    url='https://gitlab.com/chadsgilbert/makefile2dot',
    classifiers=[
        'Programming Language :: Python :: 3.7',
        'Operating System :: POSIX'
        ],
)
