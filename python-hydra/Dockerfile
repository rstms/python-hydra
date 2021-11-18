# use BASE_IMAGE build argument
ARG BASE_IMAGE=python:3.1.0-slim-buster
FROM $BASE_IMAGE

ARG PYTHON_VERSIONS='3.6 3.7 3.8 3.9 3.10'
ENV PYTHON_VERSIONS=$PYTHON_VERSIONS

# get prerequisites from https://github.com/pyenv/pyenv-installer
RUN \
  apt-get update -y && \
  apt-get -y install \
  make \
  git \
  vim \
  less \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev 


ENV USER=hydra

RUN \
  adduser ${USER} && \
  mkdir -p /home/${USER}/.local/bin && \
  chown -R ${USER}.${USER} /home/${USER} 

USER ${USER}
WORKDIR /home/${USER}

ENV PATH="/home/${USER}/.local/bin:${PATH}"

ENV PYENV_ROOT=/home/${USER}/.pyenv
ENV PATH="${PYENV_ROOT}/bin:${PATH}"
ENV PYENV_INIT_SCRIPT=/home/${USER}/.pyenv_init

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
RUN pyenv update

RUN \
  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' > $PYENV_INIT_SCRIPT && \
  echo 'eval "$(pyenv init --path)"' >> $PYENV_INIT_SCRIPT && \
  echo 'eval "$(pyenv init -)"' >> $PYENV_INIT_SCRIPT && \
  echo 'eval "$(pyenv virtualenv-init -)"' >> $PYENV_INIT_SCRIPT && \
  echo ". $PYENV_INIT_SCRIPT" >> /home/${USER}/.profile

RUN \
  for VERSION in $PYTHON_VERSIONS; do (pyenv install -l|grep "^ *${VERSION}\."|tail -1); done | \
    xargs -n 1 -I VERSION pyenv install VERSION

RUN pyenv versions
