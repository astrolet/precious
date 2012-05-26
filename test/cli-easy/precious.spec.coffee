CLIeasy = require('cli-easy')
matches = require('./matches-async')


CLIeasy.describe('precious')
  .use('precious')

  .discuss('by itself, with no arguments')
    .expect('returns `man precious`', matches.man?.precious1)
  .undiscuss()

  .discuss('command')

  .discuss('h, short for help')
    .arg('-h')
    .expect('same as `man precious`', matches.man?.precious1)
  .undiscuss()
  .arg('--help').discuss('help')
    .expect('same as `man precious`', matches.man?.precious1)
  .undiscuss()
  .arg('--help json').discuss('help json')
    .expect('is `man precious-json`', matches.man?.json7)
  .undiscuss()

  .export(module)

