[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.7786710.svg)](https://zenodo.org/record/7786710) 

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/eeholmes/earthdata-cloud-cookbook?quickstart=1&editor=jupyter)
[![Open in Codeanywhere](https://codeanywhere.com/img/open-in-codeanywhere-btn.svg)](https://app.codeanywhere.com/#https://github.com/eeholmes/earthdata-cloud-cookbook?quickstart=1&editor=jupyter)
# Hello!

This Earthdata Cloud Cookbook is being developed by the [NASA Openscapes team](https://nasa-openscapes.github.io/).

## How to contribute to our book

Information for our team [to contribute to the Cookbook](https://nasa-openscapes.github.io/earthdata-cloud-cookbook/contributing/). This includes setup and workflow instructions.

## Hackdays

In 2023 we are iterating and improving on our original cookbook structure, incorporating current technical approaches and what we've learned teaching NASA colleagues and Earth science researchers. We will increasingly track our tasks and progress using [issues](https://github.com/nasa-openscapes/earthdata-cloud-cookbook) in this repository. We are having ongoing virtual Hackdays ([ongoing notes](https://docs.google.com/document/d/1fzT-iSFlWZLS38eoPmFseljyMKDQIAc-24qH6QpnRCc/edit) and [spreadsheet](https://docs.google.com/spreadsheets/d/10WC19Rrkq7YM1P3cc6qjI8rm8yi7yiYo/edit#gid=877539921)) to focus progress together.

Hackdays:

-   February 2, 2023
-   March 2, 2023
-   March 30, 2023
-   May 10, 2023

### Hackday 4 Summary

This was our first Hackday "opening up" to folks beyond the NASA Mentors. Thanks Owen Littlejohns for joining and contributing! 

- OPeNDAP: Cassie & Chris added OPeNDAP access to how-do-i > access data > if I’m local
Merged branch into cookbook main! https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/202#pullrequestreview-1421457010 

- harmony-py: Amy and Owen added Harmony to how-do-i > subset data https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/187/commit s . Nearly ready to merge but zoom screensharing stopped


### **Hackday 3 Summary**

Brief planning check-in and then mostly worked in breakouts the whole time - 

-   OPeNDAP tutorial (Chris) - goal to not use pyDAP, instead earthaccess/Xarray and Zarr.

    -   Progress: Added auth steps and CMR query. [Notebook](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/blob/177-opendap-tutorials/how-tos/working-with-data-in-cloud/Earthdata_Cloud__Data_Access_OPeNDAP_Example.ipynb); [issue #177](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/issues/177)

-   How-Tos: Harmony-py subset example with PO.DAAC data (Amy) 

    -   Progress: Pushed work-in-progress to branch, [draft PR](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/187) 

-   How-Tos: Populated \"access data\"; created \"read data\" for python. (Cassie & Andy) 

    -   Progress: [merged PR](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/190)

    -   Next steps: Tagging R people fill in their wisdom - please go through and populate some of the R parts

-   Tutorials: Import AppEEARS tutorial (Mahsa & Julie)

    -   Progress: successful import and [draft PR](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/189)

    -   Question: not re-import all notebooks each time (see draft PR)	

-   Tutorials: earthaccess walk-through (Jess). Shared workflow with Luis (conversation below). Focus: how to use earthaccess outside the JupyterHub

-   Get-Started section (Jess) -  reviewed [old chapters commented out in quarto_yml](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/blob/188cfd30dfff6573c65af371cda171a46adb5841/_quarto.yml#L87-L91) to see how to incorporate/delete. 

    -   Progress: notes/suggestions below

    -   Next steps: review & do!

-   Environments chapter (Erin) started, notes here: [#186](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/186) 

-   DOI, Zenodo, Citation, Documentation (Stef) - Deposit in Zenodo & get DOI for cookbook [#178](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/issues/178). Added DOI badge to README: [commit](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/commit/4a825bf8b7fe1dd476019704f107449cc3e76177)

    -   woohoo <https://zenodo.org/record/7786711>

    -   Next steps: review pull request for citation text:[ #191](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/191) 

    - Next steps: create Openscapes Zenodo Community (a là [NASA TOPS](https://zenodo.org/communities/tops/) & add Cookbook et al there)


### **Hackday 2 Summary**

At our 2nd hackday we had a brief overview of cookbook progress since we'd last met before working in breakout groups together. In this session: 

-   Updated the importer function by adding .md capability and rethinking storing copies of notebooks bc will get out of sync ([commit](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/commit/540e30545062dc6528f57aa9e1a83a9b66a46fe2)) (Cassie+Luis)

-   added CC-BY [license](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/blob/main/LICENSE.md) and added [license text to page footer](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/commit/6841a703346eeb3e93d798a6f7e244df792cfac5) (Erin+Stef)

-   Planned How-Tos restructure through organization & level of granularity on left and right nav ([draft PR](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/182)) (Andy, Catalina, Mahsa, Alexis, Julie)

-   Update and add Cloud OPeNDAP tutorials ([issue](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/issues/177)) (Chris, Michele)

-   Reviewing earthaccess tutorial in cookbook to parse and point to the docs; also [how to sync a forked repo](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork#syncing-a-fork-branch-from-the-command-line) via cmd line (Jess)

### **Progress following Hackday 1**

-   [\_CookbookTutorialsInventory_Feb_2023.xlsx](https://docs.google.com/spreadsheets/d/10WC19Rrkq7YM1P3cc6qjI8rm8yi7yiYo/edit#gid=877539921) that Catalina made to identify Tutorials in the Cookbook and track decisions and progress for updating; and [Imported Cloud Hackathon Tutorials](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/pull/176) so this content is available to modernize in the cookbook

-   [Reorg How-Tos structure as "How Do I..."](https://nasa-openscapes.github.io/earthdata-cloud-cookbook/how-tos/) - the work that Andy led to restructure the How-Tos structure to be more goal-oriented

-   [Cookbook GitHub Issues](https://github.com/NASA-Openscapes/earthdata-cloud-cookbook/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc) - began organizing ideas in Issues

