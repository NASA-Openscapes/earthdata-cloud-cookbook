## devcontainer-focused Rocker
FROM docker.io/rocker/binder:4.3

USER root

## latest version of geospatial libs
RUN /rocker_scripts/experimental/install_dev_osgeo.sh
RUN apt-get update -qq && apt-get -y install vim

# conda
ENV CONDA_ENV=/opt/miniforge3
ENV PATH=${PATH}:$CONDA_ENV/bin
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_ENV} 

RUN chown ${NB_USER}:staff -R ${CONDA_ENV}

# podman doesn not understand group permissions
RUN chown ${NB_USER}:staff -R ${VIRTUAL_ENV}
RUN chown ${NB_USER}:staff -R ${R_HOME}/site-library



## codeserver
RUN curl -fsSL https://code-server.dev/install.sh | sh

USER rstudio
WORKDIR /home/rstudio
RUN usermod -s /bin/bash rstudio

COPY requirements.txt requirements.txt
ENV PATH=$PATH:/home/rstudio/.local/bin

RUN python -m pip install -r requirements.txt && rm requirements.txt
COPY install.R install.R
RUN Rscript install.R && rm install.R

# equivalent path to -n openscapes
ENV MY_ENV=${CONDA_ENV}/envs/openscapes
RUN wget https://github.com/NASA-Openscapes/corn/raw/main/ci/environment.yml && \
    conda env create -p ${MY_ENV} -f environment.yml

# some teaching preferences
RUN git config --global pull.rebase false

# NOTES: 
# conda (base) just means $CONDA_ENV/bin/
# conda (openscapes) means $MY_ENV, identically, $CONDA_ENV/envs/openscapes/bin/
# Rather than activate it or alter path, we just get it set up as an optional kernel
# We could easily make either the default by putting either bin path at the start of PATH 

RUN ${MY_ENV}/bin/python -m pip install ipykernel && \
    ${MY_ENV}/bin/python -m ipykernel install --sys-prefix --name=openscapes

#ENV PATH=${MY_ENV}/bin:${PATH}

COPY conda_init.sh /etc/profile.d/conda_init.sh
RUN bash -c /etc/profile.d/conda_init.sh



