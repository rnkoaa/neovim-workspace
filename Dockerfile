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

RUn add-apt-repository -y -r ppa:chris-lea/node.js \
  && rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list \
  && rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save \
  && curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -

ENV HOME /home/neovim

RUN groupdel users \
  && groupadd -r neovim \
  && useradd --create-home --home-dir $HOME -r -g neovim neovim

USER neovim

RUN git clone https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

RUN wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true

WORKDIR $HOME
ENV PATH "$HOME/.local/bin:${PATH}"

# RUN mkdir -p $HOME/.config/lua \
#   $HOME/.config/nvim/undodir \
#   $HOME/.config/plugin \
#   $HOME/.neovim.d \
#   $HOME/.local

# RUN pip3 install \
#   --trusted-host pypi.org \
#   --trusted-host files.pythonhosted.org \
#   --user neovim pipenv

# # COPY ./init.lua $HOME/.config/nvim/init.lua
# # COPY ./utils.lua $HOME/.config/nvim/lua/utils.lua
# # COPY ./lsp_config.lua $HOME/.config/nvim/lua/lsp_config.lua
# # COPY ./plugins.lua $HOME/.config/nvim/lua/plugins.lua

# ENTRYPOINT ["zsh"]
ENTRYPOINT ["sh"]
