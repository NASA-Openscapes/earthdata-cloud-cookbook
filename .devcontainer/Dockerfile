## devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

## latest version of geospatial libs
RUN /rocker_scripts/experimental/install_dev_osgeo.sh

## install vim for convenience
## texlive installed for install_jupyter.sh because it tries to install some basic tex libraries
RUN apt-get update -qq && apt-get -y install vim texlive

# standard python/jupyter setup
ENV NB_USER=rstudio
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${VIRTUAL_ENV}/bin:${PATH}
RUN wget https://github.com/rocker-org/rocker-versioned2/raw/master/scripts/install_jupyter.sh && \
  bash -e install_jupyter.sh && \
  rm install_jupyter.sh && \
  chown ${NB_USER}:staff -R ${VIRTUAL_ENV}

# Set up conda
ENV CONDA_ENV=/opt/miniforge3
ENV PATH=${PATH}:$CONDA_ENV/bin
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_ENV} && \
    chown ${NB_USER}:staff -R ${CONDA_ENV}

# podman doesn't not understand group permissions
RUN chown ${NB_USER}:staff -R ${R_HOME}/site-library

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
RUN python -m pip install -r requirements.txt && rm requirements.txt
COPY install.R install.R
RUN Rscript install.R && rm install.R

# Create a conda-based env and install into it without using conda init/conda activate
# (this yaml file doesn't include everything from pangeo, consider a different one...)
ENV MY_ENV=${CONDA_ENV}/envs/openscapes
RUN wget https://github.com/NASA-Openscapes/corn/raw/main/ci/environment.yml && \
    conda env create -p ${MY_ENV} -f environment.yml

# This won't be the default enviornment but we register it
RUN ${MY_ENV}/bin/python -m pip install ipykernel && \
    ${MY_ENV}/bin/python -m ipykernel install --prefix /opt/venv --name=openscapes



