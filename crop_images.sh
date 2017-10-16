#!/bin/bash

# (Some of) the figures `images/fig_??_*.png` have a lot of white space.
# Fix this.

function auto_crop_figure {
    file_name=$1
    convert ${file_name} \
        -trim -bordercolor White -border 20x10 +repage \
        ${file_name}_cropped
    mv ${file_name}_cropped ${file_name}
}
export -f auto_crop_figure

find images/fig_??_*.png -print0 | \
    xargs -0 -n1 -P1 -I {} bash -c "auto_crop_figure {}"
