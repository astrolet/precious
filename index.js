require("coffee-script");

// Exports
[ 'ephemeris'
].forEach(function(name) {
  var path = './bin/' + name.toLowerCase();
  exports[name] = require(path);
});

