CLIeasy = require('cli-easy')
doMatch = require('./matches-async')

matches = {}
doMatch.on "data", (data) -> matches = data
doMatch.on "ready", ->
  # console.log JSON.stringify matches

CLIeasy.describe('precious')
  .use('precious')

  .discuss('by itself, with no arguments')
    .expect('returns `man precious`', matches.man?.precious1)
  .undiscuss()

  .discuss('command')

    .discuss('?, short for help')
      .arg('?')
      .expect('same as `man precious-readme`', matches.man?.readme7)
    .undiscuss()

    .arg('help').discuss('help')
      .expect('same as `man precious-readme`', matches.man?.readme7)
    .undiscuss()

    .arg('help json').discuss('help json')
      .expect('is `man precious-json`', matches.man?.json7)
    .undiscuss()

  .export(module)

