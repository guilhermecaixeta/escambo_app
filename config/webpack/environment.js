const { environment } = require('@rails/webpacker');
const erb             = require('./loaders/erb')
const webpack         = require('webpack')

environment.loaders.append('erb', erb)

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    jquery: "jquery",
    "window.Tether": "tether",
    Popper: ["@popperjs/core", "default" ] // for Bootstrap 5
  })
);

environment.loaders.prepend('erb', erb)
module.exports = environment