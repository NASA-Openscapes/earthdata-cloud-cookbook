import os
import shutil

import nbformat as nbf
import pytest

from quarto_import import import_remote, inject_content

LOCAL_IMPORT_PATH = '../external'


def test_quarto_import_can_import_remote():
    remote_url = 'https://raw.githubusercontent.com/nasa-jpl/itslive-explorer/main/notebooks/itslive-notebook-rendered.ipynb'
    import_remote(remote_url, '_test.ipynb')
    assert os.path.exists(f'{LOCAL_IMPORT_PATH}/_test.ipynb') is True


def test_quarto_import_can_inject_content():
    remote_url = 'https://raw.githubusercontent.com/nasa-jpl/itslive-explorer/main/notebooks/itslive-notebook-rendered.ipynb'

    notebook = '_test.ipynb'
    content = f"""\
    # This is a test, should be at the top
    """
    inject_content(content, notebook)
    nb = nbf.read(f'{LOCAL_IMPORT_PATH}/_test.ipynb', as_version=4)
    assert nb['cells'][0]['cell_type'] == 'markdown'
    assert content in nb['cells'][0]['source']
    # Needs to be refactored into a local clean
    import_remote(remote_url, notebook)
