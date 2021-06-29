---
title: Contributing
---

## Intro

This Section is about how our Openscapes Cohort collaborates to create this book, with an eye towards how others could collaborate with us in the future. 

Our style of working is greatly influenced by: 

- [The Turing Way Community Handbook](https://the-turing-way.netlify.app/community-handbook/community-handbook.html)
- [The Carpentries Curriculum Development Handbook](https://carpentries.github.io/curriculum-development)

## Quarto

We're making the EarthData Cloud Cookbook with **Quarto**: [quarto.org](https://quarto.org/). Quarto makes collaborating to create technical documentation streamlined because we work in plain text documents that can have executable code (Python, R) and are rendered using Jupyter and Knitr engines.

What is Quarto? Quarto builds from what RStudio learned from RMarkdown but enables different engines (Jupyter and knitr). It is both a Command Line Tool and R package. `.qmd` is a new filetype like `.Rmd` --- meaning it's a text file but coupled with an engine can execute code and be rendered as html, pdf, word, and beyond --- but for other languages like Python. Quarto can convert `.ipynb` files to and from `.md` and `.qmd` easily so you can develop and publish with collaborators that have different workflows. Once the book is "served" locally, `.md` files auto-update as you edit, and files with executable code can be rendered individually, and the behavior of different code chunks can be controlled and cached.

(Note: with Quarto, e-books and websites are very similarly structured, with e-books being set up for numbered chapters and references and websites set up for higher number of pages and organization. We can talk about our book as a book even as we explore whether book/website better suits our needs. This is assigned in `_quarto.yml`, as we'll explore later).
