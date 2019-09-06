#!/usr/bin/bash
#
# Copyright Tarkan Al-Kazily 2019
#
# Compiles a markdown file to pdf
# All resources necessary for markdown file must be present in same or sub directory

if [[ "$#" -ne 2 ]]; then
    echo -e "Not enough arguments"
    echo -e "Usage: ./compile_pdf.sh <input.md> <output.pdf>"
fi

dir=$(readlink -f `dirname $1`)
input=`basename $1`
outdir=$(readlink -f `dirname $2`)
output=`basename $2`

docker run --rm -v "$dir":/home/jovyan/work -v "$outdir":/home/jovyan/out tarkanalkazily/jupyter-python2:latest \
    sh -c "cd /home/jovyan/work && \
           pandoc /home/jovyan/work/$input --pdf-engine=xelatex \
                -o /home/jovyan/out/$output \
                -V geometry=margin=1in"
