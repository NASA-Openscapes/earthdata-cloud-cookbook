# devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

# latest version of geospatial libs
RUN /rocker_scripts/experimental/install_dev_osgeo.sh && rm -rf /build_*
# install vim for convenience
RUN apt-get update -qq && apt-get -y install vim

# some teaching preferences
RUN git config --system pull.rebase false && \
    git config --system credential.helper 'cache --timeout=36000'

# codeserver; Adds the VSCode button
RUN curl -fsSL https://code-server.dev/install.sh | sh && rm -rf .cache

# Set up conda
ENV NB_USER=rstudio
ENV CONDA_ENV=/opt/miniforge3
ENV PATH=${CONDA_ENV}/bin:${PATH}
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_ENV} && \
    chown ${NB_USER}:staff -R ${CONDA_ENV} && \
    rm -f Miniforge3*.sh *.deb

# Tell RStudio how to find Python
RUN echo "PATH=${PATH}" >>"${R_HOME}/etc/Renviron.site"

# install R packages into the site library
COPY install.R install.R
RUN Rscript install.R && rm install.R

# Initialize conda by default for all users:
RUN conda init --system

# Standard user setup here
USER ${NB_USER} 
WORKDIR /home/${NB_USER}
# make bash default shell
RUN usermod -s /bin/bash ${NB_USER} 

COPY environment.yml environment.yml
RUN conda env update -f environment.yml && conda clean --all

