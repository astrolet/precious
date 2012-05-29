require("coffee-script");

// Exports
[ 'ephemeris'
].forEach(function(name) {
  var path = './lib/' + name.toLowerCase();
  exports[name] = require(path);
});

