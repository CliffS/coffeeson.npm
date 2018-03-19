coffee = require 'coffeescript'
fs     = require 'fs'


# @private - Compiles coffeeson content to JS with coffee-script
compile = (src) ->
  coffee.compile src.toString(), bare: yes

# Parse a coffeeson string and return a JS native object
parse = (src) ->
  eval compile(src)

# Parse a coffeeson file and return a JS native object
parseFile = (name, cb) ->
  new Promise (resolve, reject) =>
    fs.readFile name, (err, src) ->
      if err then reject err else resolve parse src

# Parse a coffeeson string and return JSON
toJSON = (src, replacer, spacer) ->
  JSON.stringify parse(src), replacer, spacer

# Parse a coffeeson string and return pretty JSON
toJSON.pretty = (src, replacer) ->
  toJSON src, replacer, 2

# Asynchronously read a file and callback with the content as JSON
fileToJSON = (name, args...) ->
  new Promise (resolve, reject) =>
    fs.readFile name, (err, src) ->
      if err then reject err else resolve toJSON src, args...

# Asynchronously read a file and callback with the content as pretty JSON
fileToJSON.pretty = (name) ->
  fileToJSON name, null, 2

# Asynchronously read a file and save a .json file right next the source file
convertFile = (name, args...) ->
  new Promise (resolve, reject) =>
    fileToJSON name, args...
    .then (json) =>
      fs.writeFile name.replace(/\.[^.]+$/, '.json'), json, (err) =>
        if err then reject err else resolve json

# Asynchronously read a file and save a pretty .json file right next the source file
convertFile.pretty = (name) ->
  convertFile name, null, 2

# Export methods
module.exports = {
  parse
  parseFile
  toJSON
  fileToJSON
  convertFile
}
