require.paths.unshift "#{__dirname}/node_modules"

fs = require 'fs'
docs = "#{__dirname}/docs"

{basename, join} = require 'path'
{exec, spawn} = require 'child_process'
inspect = require('eyes').inspector({stream: null, pretty: false, styles: {all: 'magenta'}})
watchTree = require('watch-tree').watchTree
{series, parallel} = require 'async'


handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember you need to `npm install` the package.json devDependencies and also `bundle install`.\033[0;37m\n"
    console.log err.stack

sh = (command) -> (k) -> exec command, k

# Modified from https://gist.github.com/920698
runCommand = (name, args) ->
    proc = spawn name, args
    proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
    proc.stdout.on 'data', (buffer) -> console.log buffer.toString()
    proc.on 'exit', (status) -> process.exit(1) if status != 0

docsInit = (callback) ->
  series [
    (sh "rm -rf #{docs}")
    (sh "mkdir -p #{docs}/bin")
  ], (err) -> throw err if err


task 'assets:watch', 'Watch source files and build docs', (options) ->

  watchPython = ->
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

  series [
    docsInit
    watchPython()
  ], (err) -> throw err if err


# Build manuals / gh-pages almost exactly like https://github.com/josh/nack does

task 'man', "Build manuals", ->
  fs.readdir "doc/", (err, files) ->
    for file in files when /\.md/.test file
      source = join "doc", file
      target = join "man", basename source, ".md"
      exec "ronn --pipe --roff #{source} > #{target}", (err) ->
        throw err if err

task 'pages', "Build pages", ->

  buildMan = (callback) ->
    series [
      (sh "cp README.md doc/index.md")
      (sh "ronn -stoc -5 doc/*.md")
      (sh "mv doc/*.html pages/")
      (sh "rm doc/index.md")
    ], callback

  buildAnnotations = (callback) ->
    series [
      docsInit
      (runCommand "pycco", ["-d", "docs/bin", "bin/precious.py"])
      (sh "cp docs/bin/* pages/annotations/bin")
    ], callback

  build = (callback) ->
    parallel [buildMan, buildAnnotations], callback

  series [
    (sh "rm -rf pages/*")
    (sh "mkdir -p pages/annotations/bin")
    build
  ], (err) -> throw err if err

task 'pages:publish', "Publish pages", ->

  checkoutBranch = (callback) ->
    series [
      (sh "rm -rf pages/")
      (sh "git clone -q -b gh-pages git@github.com:astrolet/precious.git pages")
      (sh "rm -rf pages/*")
    ], callback

  publish = (callback) ->
    series [
      (sh "cd pages/ && git add . && git commit -m 'rebuild manual' || true")
      (sh "cd pages/ && git push git@github.com:astrolet/precious.git gh-pages")
      (sh "rm -rf pages/")
    ], callback

  series [
    checkoutBranch
    (sh "cake pages") # NOTE: (invoke "pages") # doesn't work here after checkoutBranch
    publish
  ], (err) -> throw err if err
