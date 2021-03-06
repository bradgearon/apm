path = require 'path'

optimist = require 'optimist'

Command = require './command'

module.exports =
class Test extends Command
  @commandNames: ['test']

  parseOptions: (argv) ->
    options = optimist(argv)

    options.usage """
      Usage:
        apm test

      Runs the package's tests contained within the spec directory (relative
      to the current working directory).
    """
    options.alias('h', 'help').describe('help', 'Print this usage message')
    options.alias('p', 'path').string('path').describe('path', 'Path to atom command').string('path')

  showHelp: (argv) -> @parseOptions(argv).showHelp()

  run: (options) ->
    {callback} = options
    args = @parseOptions(options.commandArgs)
    env = process.env

    atomCommand = args.argv.path ? 'atom'
    @spawn atomCommand, ['--dev', '--test', "--spec-directory=#{path.join(process.cwd(), 'spec')}"], {env, streaming: true}, (code) ->
      if code is 0
        process.stdout.write 'Tests passed\n'.green
        callback()
      else
        callback('Tests failed')
