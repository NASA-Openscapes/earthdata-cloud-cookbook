---
title: Contributing
---

## Intro

This section describes how our NASA Openscapes team collaborates to create this Cookbook, with an eye towards how others could collaborate with us in the future. 

Our style of working is greatly influenced by: 

- [The Turing Way Community Handbook](https://the-turing-way.netlify.app/community-handbook/community-handbook.html)
- [The Carpentries Curriculum Development Handbook](https://carpentries.github.io/curriculum-development)
- [The Documentation System](https://documentation.divio.com/)

## Quarto

We're making the EarthData Cloud Cookbook with **Quarto**: [quarto.org](https://quarto.org/). Quarto makes collaborating to create technical documentation streamlined because we work in plain text documents that can have executable code (Python, R) and are rendered using Jupyter and Knitr engines.

What is Quarto? Quarto builds from what RStudio learned from RMarkdown but enables different engines (Jupyter and knitr). It is both a Command Line Tool and R package. `.qmd` is a new filetype like `.Rmd` --- meaning it's a text file but when coupled with an engine that executes code it can be rendered as html, pdf, word, and beyond. Collaborators can develop text and notebooks in wherever they are most comfortable. Then Quarto builds them together as a book or website, even converting between file types like `.ipynb`, `.md` and `.qmd` it's a streamlined was to develop and publish with collaborators that have different workflows. Once the book is "served" locally, `.md` files auto-update as you edit, and files with executable code can be rendered individually, and the behavior of different code chunks can be controlled and cached.

(Note: with Quarto, e-books and websites are very similarly structured, with e-books being set up for numbered chapters and references and websites set up for higher number of pages and organization. We can talk about our book as a book even as we explore whether book/website better suits our needs. Our Cookbook is currently a website; this is assigned in `_quarto.yml`, as we'll explore later).
