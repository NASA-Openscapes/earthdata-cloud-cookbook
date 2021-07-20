from typing import List

def get_data_links(related_links: List, filter: str):
    """
    get only the data links from the CMR entry
    """
    matched_links = []
    for l in related_links:
        if l['Type'] == filter:
            matched_links.append(l)
    return matched_links

