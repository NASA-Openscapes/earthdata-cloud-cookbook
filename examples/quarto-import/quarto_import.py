#!/usr/bin/env python
import argparse
import json
import os
from datetime import date

import requests
import nbformat as nbf
from pqdm.processes import pqdm

IMPORTED_PATH = '.imported'

def open_json(file_path):
    with open(file_path) as f:
        json_input = json.load(f)
    return json_input

def import_remote(url, target):
    if not os.path.exists(IMPORTED_PATH):
        print('recreating local')
        os.mkdir(IMPORTED_PATH)
    remote_file = requests.get(url)
    with open(f'{IMPORTED_PATH}/{target}', 'wb') as f:
        f.write(remote_file.content)
    return None

def inject_content(content, notebook):
    nb = nbf.read(f'{IMPORTED_PATH}/{notebook}', as_version=4)
    preamble_cell = nbf.v4.new_markdown_cell(content)
    # for some reason v4 says id is not part of the schema.
    preamble_cell.pop('id', None)
    nb['cells'].insert(0, preamble_cell)
    nbf.write(nb, f'{IMPORTED_PATH}/{notebook}')


def create_preamble_cell(document):
    target = document['target']
    url = document['url']
    import_date = date.today().strftime('%Y-%m-%d')
    cell_content = f"""\
    # {document['title']}
    imported on: **{import_date}**

    {document['description']}

    > The original source for this document is {document['source']}

    """
    return cell_content


def process_document(document):
    local_target = document['target']
    url = document['url']
    import_remote(url, local_target)
    if document['process'] is True:
        preamble_cell =  create_preamble_cell(document)
        inject_content(preamble_cell, local_target)
    print(f'Processed: {local_target}')



def main(json_input):
    """
    This module will fetch a URL, save it locally and inject some preamble
    The currently supported formats are: .ipynb
    """
    for document in json_input:
        process_document(document)
    # result = pqdm(json_input, process_document, n_jobs=2)
    return None



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Ipython importer")
    # parameters
    parser.add_argument('-f',
                        '--file',
                        help = "File to parse",
                        type = str)
    args=parser.parse_args()
    documents_to_import = open_json(args.file)
    result = main(documents_to_import)
