#!/usr/bin/env coffee
#

Cson = require './coffeeson'
Getopts = require 'getopts'

options = Getopts process.argv[2..],
  alias:
    h: [ 'help', '?' ]
    V: 'version'
    n: 'no-pretty'
  boolean: [ 'h', 'V', 'p' ]
  unknown: (option) => false

syntax = ->
  console.log """
    coffeeson [ flags ] filename [filename...]
    flags:  -h --help      -- this text
            -V --version   -- display version and exit
            -n --no-pretty -- don't prettify the output
    """
  process.exit 1

version = ->
  pack = require '../package.json'
  console.log "coffeeson version #{pack.version}"
  process.exit()

# console.log options
do syntax if options.help
do version if options.version

do syntax unless options._.length

cson = Cson.convertFile
cson = cson.pretty unless options.n

for filename in options._
  do (filename) ->
    try
      await cson filename
      console.log "Processed: #{filename}"
    catch err
      console.error "#{filename}: #{err}"

