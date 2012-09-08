exec = require('child_process').exec

# There are several man pages, reused for help.
module.exports = (page, cb) ->
  exec "man man/#{page}", (err, stdout, stderr) ->
    if err
      if cb then cb err, stderr.toString()
      else
        console.error "Can't get: `man #{page}`.".red
        console.error "Go to http://astrolet.github.com/precious/ for help."
        process.exit(1)
    else
      if cb then cb null, "\n#{stdout}\n"
      else
        console.log "\n" + stdout
        process.exit(0)

