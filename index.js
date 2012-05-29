require("coffee-script");

// Exports
[ 'ephemeris', 'convenient'
].forEach(function(name) {
  var path = './lib/' + name.toLowerCase();
  exports[name] = require(path);
});

