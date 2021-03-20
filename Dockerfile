FROM node:15-buster

# FROM ubuntu:20.04

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt update \
  && apt upgrade -y \
  && apt install -y -q --no-install-recommends \
    locales locales-all \
    build-essential \
    apt-transport-https \
    ca-certificates \
    libssl-dev \
    libffi-dev \
    python3-dev \
    libfuse-dev \
  && apt install -y \
    python3-pip \
    curl \
    wget \
    git \
    zsh \
    zip \
    unzip \
    xclip \
    fonts-cascadia-code \
  && apt clean all \
  && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
ENV GO_VERSION 1.16.2
ENV GO_URL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"

RUN npm install -g npm \
  && npm install -g typescript \
  neovim \
  dockerfile-language-server-nodejs \
  typescript-language-server \
  vscode-json-languageserver \
  vscode-html-languageserver-bin \
  bash-language-server \
  && pip3 install python-language-server\
  && mkdir /neovim \
  && cd /neovim \
  && wget -q https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
  && chmod +x ./nvim.appimage \
  && ./nvim.appimage --appimage-extract \
  && mv squashfs-root / && ln -s /squashfs-root/AppRun /usr/bin/nvim \
  && wget -q $GO_URL \
  && tar -xvf "go${GO_VERSION}.linux-amd64.tar.gz" -C /usr/local/

ENV HOME /home/neovim

RUN groupdel users \
  && groupadd -r neovim \
  && useradd --create-home --home-dir $HOME -r -g neovim neovim

USER neovim

ENV GO111MODULE=on 
ENV NPM_PACKAGES "${HOME}/.npm-packages"
ENV GOROOT "/usr/local/go"
ENV GOPATH "$HOME/go"
ENV PATH "$HOME/.local/bin:${GOPATH}/bin:${GOROOT}/bin:${NPM_PACKAGES}:${PATH}"

RUN git clone https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim \
  && mkdir /home/neovim/go \
  && pip3 install \
  --trusted-host pypi.org \
  --trusted-host files.pythonhosted.org \
  --user neovim pipenv \
  && wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true \
  && mkdir -p /home/neovim/.config/nvim/lua \
  && mkdir "${HOME}/.npm-packages" \
  && npm config set prefix "${HOME}/.npm-packages" \
  && go get golang.org/x/tools/gopls@latest

WORKDIR $HOME

VOLUME /home/neovim/.config
VOLUME /home/neovim/.local

# RUN mkdir -p $HOME/.config/lua \
#   $HOME/.config/nvim/undodir \
#   $HOME/.config/plugin \
#   $HOME/.neovim.d \
#   $HOME/.local

# RUN # # COPY ./init.lua $HOME/.config/nvim/init.lua
# # COPY ./utils.lua $HOME/.config/nvim/lua/utils.lua
# # COPY ./lsp_config.lua $HOME/.config/nvim/lua/lsp_config.lua
# # COPY ./plugins.lua $HOME/.config/nvim/lua/plugins.lua

ENTRYPOINT ["zsh"]
