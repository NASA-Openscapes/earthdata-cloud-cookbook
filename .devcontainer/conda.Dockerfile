# devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

## Set the default shell
ENV SHELL=/bin/bash

# latest version of geospatial libs -- big! 
# RUN /rocker_scripts/experimental/install_dev_osgeo.sh && rm -rf /build_*
# install vim for convenience

RUN apt-get update -qq && apt-get -y install vim

# some teaching preferences
RUN git config --system pull.rebase false && \
    git config --system credential.helper 'cache --timeout=36000'

# codeserver; Adds the VSCode button
RUN curl -fsSL https://code-server.dev/install.sh | sh && rm -rf .cache

# Rename the rstudio user as jovyan
RUN usermod -l jovyan rstudio && \
    usermod -d /home/jovyan -m jovyan && \
    groupmod -n jovyan rstudio


# Set up conda
ENV NB_USER=jovyan
ENV CONDA_DIR=/opt/miniforge3
ENV CONDA_ENV=openscapes
ENV NB_PYTHON_PREFIX=${CONDA_DIR}/envs/${CONDA_ENV} 
ENV PATH=${NB_PYTHON_PREFIX}/bin:/${CONDA_DIR}/bin:${PATH}

# install conda
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_DIR} && \
    chown ${NB_USER}:staff -R ${CONDA_DIR} && \
    rm -f Miniforge3*.sh *.deb

# conda decorators
RUN conda init --system
RUN echo ". ${CONDA_DIR}/etc/profile.d/conda.sh ; conda activate ${CONDA_ENV}" > /etc/profile.d/init_conda.sh

# Tell RStudio how to find Python
RUN echo "PATH=${PATH}" >>"${R_HOME}/etc/Renviron.site"

# install R packages into the site library
COPY install.R install.R
RUN Rscript install.R && rm install.R

# Standard user setup here
USER ${NB_USER} 
WORKDIR /home/${NB_USER}
# make bash default shell
RUN usermod -s /bin/bash ${NB_USER} 

COPY environment.yml environment.yml
RUN conda env update -f environment.yml && conda clean --all

