## devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

## latest version of geospatial libs
RUN /rocker_scripts/experimental/install_dev_osgeo.sh && rm -rf build_*
RUN apt-get update -qq && apt-get -y install vim

# standard python/jupyter setup
ENV NB_USER=rstudio
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${VIRTUAL_ENV}/bin:${PATH}
RUN /rocker_scripts/install_python.sh && \
  chown ${NB_USER}:staff -R ${VIRTUAL_ENV}

# podman doesn't not understand group permissions
# RUN chown ${NB_USER}:staff -R ${R_HOME}/site-library
RUN chown ${NB_USER}:staff ${R_HOME}/site-library

# some teaching preferences
RUN git config --system pull.rebase false && \
    git config --system credential.helper 'cache --timeout=36000'

## codeserver
RUN curl -fsSL https://code-server.dev/install.sh | sh && rm -rf .cache

## Openscapes-specific configs
USER rstudio
WORKDIR /home/rstudio
RUN usermod -s /bin/bash rstudio

# install into the default environment
COPY nasa-requirements.txt requirements.txt
RUN python -m pip install --no-cache-dir -r requirements.txt && rm requirements.txt
COPY install.R install.R
RUN Rscript install.R && rm install.R

