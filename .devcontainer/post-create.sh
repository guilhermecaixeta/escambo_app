#!/bin/bash

# An example of post create file for a devcontainer

# Source ASDF
. /usr/local/asdf/asdf.sh

echo "Installing yarn" 
npm --global install yarn 

# Install the version of Bundler specified in Gemfile.lock
if [ -f Gemfile.lock ]; then
    bundler_version=$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | tr -d ' ')
    gem install bundler -v "$bundler_version"
fi

# If there's a Gemfile, then run `bundle install`
if [ -f Gemfile ]; then
    echo "installing bundle"
    bundle install

    echo "yarn checking files"
    yarn install --check-files

    echo "Installing gems" 
    gem install rails:6.0 htmlbeautifier solargraph sorbet:0.5.10187

    # echo "initializing tapioca"
    bundle exec tapioca init
fi
