#!/bin/sh
# Builds examples/sample.png: a sunset landscape drawn entirely with engine commands.
# Usage: examples/sample-scene.sh [path/to/photocraft-cli] [out-dir]
set -eu
CLI=${1:-./linux-x86_64/photocraft-cli}
OUT=${2:-.}

"$CLI" run --new '{"width":1200,"height":800}' \
  --cmd paint.gradient --params '{"from":[600,0],"to":[600,560],"stops":[[0,"#1b1f4a"],[0.45,"#7a3b8f"],[0.8,"#f2795a"],[1,"#ffd27a"]]}' \
  --cmd shape.create --params '{"kind":"ellipse","rect":[480,330,240,240],"fill":"#ffe9a8","name":"Sun"}' \
  --cmd layer.layerStyle.outerGlow --params '{"color":"#ffcf6b","size":60,"opacity":80}' \
  --cmd shape.create --params '{"kind":"path","name":"Far mountains","fill":"#5a3570","path":{"subpaths":[{"knots":[[0,560],[180,380],[330,500],[520,340],[700,520],[880,360],[1050,480],[1200,400],[1200,800],[0,800]]}]}}' \
  --cmd shape.create --params '{"kind":"path","name":"Near hills","fill":"#2a1a3d","path":{"subpaths":[{"knots":[[0,640],[260,560],[520,650],[780,580],[1000,640],[1200,590],[1200,800],[0,800]]}]}}' \
  --cmd shape.create --params '{"kind":"star","rect":[140,90,40,40],"sides":5,"starRatio":0.45,"fill":"#fff6d0","name":"Star"}' \
  --cmd shape.create --params '{"kind":"star","rect":[980,140,28,28],"sides":5,"starRatio":0.45,"fill":"#fff6d0","name":"Star 2"}' \
  --cmd layer.new.layer --params '{"name":"Tree"}' \
  --cmd filter.render.tree --params '{"baseTreeType":3,"x":0.82,"y":0.86,"size":0.55,"seed":7}' \
  --cmd type.create --params '{"x":600,"y":740,"text":"PhotoCraft","align":"center","size":72,"color":"#ffffff","name":"Title"}' \
  --cmd layer.layerStyle.dropShadow --params '{"color":"#000000","opacity":60,"distance":4,"size":8}' \
  --out "$OUT/sample.psd"

"$CLI" convert "$OUT/sample.psd" "$OUT/sample.png"
