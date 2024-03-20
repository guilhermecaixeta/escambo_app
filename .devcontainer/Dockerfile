# An example Dockerfile for Ruby on Rails development with asdf

### ARGs
ARG DEBIAN_FRONTEND=noninteractive
ARG VARIANT=bullseye
ARG RUBY_VERSION=3.3.0
ARG NODE_JS_VERSION=20.11.1
ARG BUNDLE_VERSION=2.5.6

### FROM
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

### ARGs
ARG RUBY_VERSION
ARG NODE_JS_VERSION
ARG BUNDLE_VERSION

### ENVs
ENV APP_PATH /app
ENV PATH /home/vscode/.asdf/shims:/home/vscode/.asdf/bin:$PATH
ENV ASDF_DATA_DIR /usr/local/asdf
ENV RUBY_VERSION ${RUBY_VERSION}
ENV NODE_JS_VERSION ${NODE_JS_VERSION}

### Install all dependencies you need for your project here
RUN mkdir -p "$APP_PATH" && \
  apt-get update && \
  apt-get -y install --no-install-recommends \
  build-essential gnupg2 tar git zsh libssl-dev zlib1g-dev libyaml-dev curl libreadline-dev \
  postgresql-client libpq-dev openssh-client default-libmysqlclient-dev\
  imagemagick libjpeg-dev libpng-dev libtiff-dev libwebp-dev libvips python-dev automake autoconf libtool \
  tzdata gifsicle \
  tmux \
  vim \
  zsh

### Set the workdir
WORKDIR "$APP_PATH"

### Install asdf
RUN git clone https://github.com/asdf-vm/asdf.git /usr/local/asdf && \
  echo 'source /usr/local/asdf/asdf.sh' > /etc/profile.d/asdf.sh && \
  chmod +x /etc/profile.d/asdf.sh && \
  chown -R vscode:vscode /usr/local/asdf

# # Set the user
# USER app

## Install Brew
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

RUN brew install watchman

RUN echo -e '\n. /usr/local/asdf/asdf.sh' >> /home/vscode/.bashrc && \
  echo -e '\n. /usr/local/asdf/asdf.sh' >> /home/vscode/.zshrc && \
  echo -e "\nexport PATH=\"/home/vscode/.gems/bin:\$PATH\"" >> /home/vscode/.bashrc && \
  echo -e "\nexport PATH=\"/home/vscode/.gems/bin:\$PATH\"" >> /home/vscode/.zshrc

COPY .tool-versions ./

### SHELL
SHELL ["/bin/bash", "-lc"]

### Install Ruby and Node.js using asdf
RUN asdf plugin add ruby
RUN asdf plugin add nodejs
RUN asdf install ruby ${RUBY_VERSION}
RUN asdf install nodejs ${NODE_JS_VERSION}
RUN asdf global ruby ${RUBY_VERSION}
RUN asdf global nodejs ${NODE_JS_VERSION}

# Change ownership of ASDF installations
RUN chown -R vscode:vscode /usr/local/asdf

USER vscode

### Install bundler
COPY Gemfile Gemfile.lock ./

RUN . /usr/local/asdf/asdf.sh && \
  gem install bundler -v "~> ${BUNDLE_VERSION}"

### Expose ports
EXPOSE 3000 35729