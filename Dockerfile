FROM node:15-buster

# FROM ubuntu:20.04

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN apt update \
  && apt upgrade -y \
  && apt install -y -q --no-install-recommends \
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
  && apt clean all \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm \
  && npm install -g typescript \
  neovim \
  dockerfile-language-server-nodejs \
  typescript-language-server \
  vscode-json-languageserver \
  vscode-html-languageserver-bin \
  bash-language-server \
  pyright \
  && pip3 install python-language-server
  
RUN mkdir /neovim \
   && cd /neovim \
   && wget -q https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
   && chmod +x ./nvim.appimage \
   && ./nvim.appimage --appimage-extract \
   && mv squashfs-root / && ln -s /squashfs-root/AppRun /usr/bin/nvim 

ENV HOME /home/neovim

RUN groupdel users \
  && groupadd -r neovim \
  && useradd --create-home --home-dir $HOME -r -g neovim neovim
RUN 
USER neovim

RUN git clone https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim \
  && git clone https://github.com/savq/paq-nvim.git \
    ~/.local/share/nvim/site/pack/paqs/opt/paq-nvim \
  && curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN pip3 install \
  --trusted-host pypi.org \
  --trusted-host files.pythonhosted.org \
  --user neovim pipenv \
  && wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true 

WORKDIR $HOME
ENV PATH "$HOME/.local/bin:${PATH}"

ENTRYPOINT ["zsh"]
