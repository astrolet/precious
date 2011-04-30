{exec, spawn} = require 'child_process'
inspect = require('eyes').inspector({stream: null, pretty: false, styles: {all: 'magenta'}})
watchTree = require('watch-tree').watchTree

handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember that you need: coffee-script, watch-tree and pycco.\033[0;37m\n"
    console.log err.stack

# Modified from https://gist.github.com/920698
runCommand = (name, args) ->
    proc = spawn name, args
    proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
    proc.stdout.on 'data', (buffer) -> console.log buffer.toString()
    proc.on 'exit', (status) -> process.exit(1) if status != 0


task 'assets:watch', 'Watch source files and build docs', (options) ->

  docs = "#{__dirname}/docs"
  watch_rate = 100 #ms
  watch_info =
    1:
      path: "bin"
      options:
        'match': '.+\.py'
      events: ["filePreexisted", "fileCreated", "fileModified"]
      callback: -> console.log "you can't call me"

  # NOTE: it would be nice if the watch_info[n].callback could be called
  # ... and if we knew which event fired it - perhaps there is a way?

  watcher = {}
  for item, stuff of watch_info
    stuff.options['sample-rate'] = watch_rate
    for event in stuff.events
      watcher["#{item}-#{event}"] = watchTree(stuff.path, stuff.options)
      watcher["#{item}-#{event}"].on event, (what, stats) ->
        console.log what + ' - is being documented (due to some event), stats: ' + inspect(stats)
        if context = what.match /(.*)\/[^\/]+\.py$/ then runCommand 'pycco', ['-d', "#{docs}/#{context[1]}", what]
        else console.log "unrecognized file type of #{what}"
