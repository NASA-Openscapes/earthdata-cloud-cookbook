## devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

## Set the default shell
ENV SHELL=/bin/bash

## latest version of geospatial libs
RUN /rocker_scripts/experimental/install_dev_osgeo.sh && rm -rf build_*

## install vim
RUN apt-get update -qq && apt-get -y install vim

# standard python/jupyter setup
ENV NB_USER=rstudio
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${VIRTUAL_ENV}/bin:${PATH}
RUN /rocker_scripts/install_python.sh && \
  chown ${NB_USER}:staff -R ${VIRTUAL_ENV}

# some teaching preferences
RUN git config --system pull.rebase false && \
    git config --system credential.helper 'cache --timeout=36000'

## codeserver
RUN curl -fsSL https://code-server.dev/install.sh | sh && rm -rf .cache

## Install R packages into the site library
COPY install.R install.R
RUN Rscript install.R && rm install.R

## Openscapes-specific configs
USER rstudio
WORKDIR /home/rstudio
RUN usermod -s /bin/bash rstudio

# install into the default venv environment
COPY nasa-requirements.txt requirements.txt
RUN python -m pip install --no-cache-dir -r requirements.txt && rm requirements.txt

