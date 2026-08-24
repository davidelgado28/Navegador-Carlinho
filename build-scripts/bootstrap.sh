#!/bin/bash

echo "Iniciando configuração do ambiente de desenvolvimento..."

if [ ! -d "depot_tools" ]; then
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
export PATH="$PWD/depot_tools:$PATH"

mkdir -p browser_source && cd browser_source

fetch --nohooks chromium

cd src
gclient sync --with_branch_heads --with_tags

echo "Ambiente base do Chromium baixado com sucesso!"
