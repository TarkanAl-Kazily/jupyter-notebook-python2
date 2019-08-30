#!/usr/bin/bash

docker run -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work --rm tarkanalkazily/jupyter-python2:latest
