# From https://github.com/jupyter/docker-stacks/wiki/Docker-recipes#add-a-python-2x-environment

# Choose your desired base image: you could use another from https://github.com/busbud/jupyter-docker-stacks
FROM jupyter/scipy-notebook:latest

# Create a Python 2.x environment using conda including at least the ipython kernel
# and the kernda utility. Add any additional packages you want available for use
# in a Python 2 notebook to the first line here (e.g., pandas, matplotlib, etc.)
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 ipython ipykernel kernda numpy && \
    conda clean --all -f -y

USER root

# Bundle requirements
# You can change the libraries in the file
# requirements.txt
ADD requirements.txt /requirements.txt

# Create a global kernelspec in the image and modify it so that it properly activates
# the python2 conda environment.
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install && \
    $CONDA_DIR/envs/python2/bin/kernda -o -y /usr/local/share/jupyter/kernels/python2/kernel.json && \
    conda install -n python2 --file /requirements.txt && \
    rm /requirements.txt

USER $NB_USER
