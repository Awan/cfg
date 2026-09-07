#!/bin/bash

# Get terminal dimensions
cols=$(tput cols)
rows=$(tput lines)
half_width=$((cols / 2))

# Run ueberzug to display image on the right half
{
    echo "{\"action\": \"add\", \"identifier\": \"right_half\", \"x\": $half_width, \"y\": 0, \"width\": $half_width, \"height\": $rows, \"path\": \"/tmp/cover.jpg\", \"scaler\": \"fit_contain\"}"
} | ueberzug layer --parser json

