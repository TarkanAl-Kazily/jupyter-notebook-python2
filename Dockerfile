# From https://github.com/jupyter/docker-stacks/wiki/Docker-recipes#add-a-python-2x-environment

# Choose your desired base image: you could use another from https://github.com/busbud/jupyter-docker-stacks
FROM jupyter/scipy-notebook:latest

# Get version 1.1.1 of jupyterlab, compatible with extensions
RUN conda install "jupyterlab=1.1.1"

# Create a Python 2.x environment using conda including at least the ipython kernel
# and the kernda utility. Add any additional packages you want available for use
# in a Python 2 notebook to the first line here (e.g., pandas, matplotlib, etc.)
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 ipython ipykernel kernda numpy && \
    conda clean --all -f -y

USER root

# Create a global kernelspec in the image and modify it so that it properly activates
# the python2 conda environment.
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install && \
    $CONDA_DIR/envs/python2/bin/kernda -o -y /usr/local/share/jupyter/kernels/python2/kernel.json

USER $NB_USER

# Add jupyter settings
ADD --chown=jovyan:users /.jupyter /home/$NB_USER/.jupyter 

# Install and build jupyterlab extensions. Add more extensions here
RUN jupyter labextension install jupyterlab_vim --no-build && \
    jupyter lab build && \
    jupyter lab clean && \
    jlpm cache clean && \
    npm cache clean --force && \
    rm -rf $HOME/.node-gyp && \
    rm -rf $HOME/.local && \
    fix-permissions $CONDA_DIR $HOME
