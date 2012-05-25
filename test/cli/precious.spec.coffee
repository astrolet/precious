CLIeasy = require('cli-easy')
exec    = require('child_process').exec

man = (page) -> exec "man #{page}", (err, out) -> "\n#{out}\n"

CLIeasy.describe('precious')
  .use('precious')
  .discuss('by itself, with no arguments')
    .expect('returns `man precious`', man 'precious')
  .undiscuss()
  .discuss('command')
    .arg('--help').discuss('help')
      .expect('same as `man precious`', man 'precious')
    .undiscuss()
    .arg('-h').discuss('h, short for help')
      .expect('same as `man precious`', man 'precious')
    .undiscuss()
    .arg('--help json').discuss('help json')
      .expect('is `man precious-json`', man 'precious-json')
  .export(module)

