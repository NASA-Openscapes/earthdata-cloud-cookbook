#!/usr/bin/env python
import argparse
import json
import os

import requests
import nbformat as nbf

IMPORTED_PATH = 'imported'

def open_json(file_path):
    with open(file_path) as f:
        json_input = json.load(f)
    return json_input

def import_remote(url, target):
    if not os.path.exists(IMPORTED_PATH):
        print('recreating local')
        os.mkdir(IMPORTED_PATH)
    remote_file = requests.get(url)
    with open(f'{IMPORTED_PATH}/remote_{target}', 'wb') as f:
        f.write(remote_file.content)
    return None

def inject_content(content, notebook):
    nb = nbf.read(f'{IMPORTED_PATH}/{notebook}', as_version=4)
    preamble_cell = nbf.v4.new_markdown_cell(content)
    # for some reason v4 says id is not part of the schema.
    preamble_cell.pop('id', None)
    nb['cells'].insert(0, preamble_cell)
    nbf.write(nb, f'{IMPORTED_PATH}/{notebook}')


def main(json_input):
    """
    This module will fetch a URL, save it locally and inject some preamble
    The currently supported formats are: .ipynb
    """
    print(json_input)
    for resource in json_input:
        target = resource['target']
        url = resource['url']
        content = f"""\
        # {resource['title']}
        {resource['description']}

        > The original source for this document is {resource['source']}

        """
        import_remote(url, target)
        if resource['process'] is True:
            inject_content(content, target)
        print(f'Processed: {target}')
    return None



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Ipython importer")
    # parameters
    parser.add_argument('-f',
                        '--file',
                        help = "File to parse",
                        type = str)
    args=parser.parse_args()
    json_inputs = open_json(args.file)
    result = main(josn_input)
    print(result)
