#!/usr/bin/env bash

gem install gosleap && mix deps.get && mix ecto.setup && cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development && cd ..
