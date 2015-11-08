_ = require "lodash"
app = require "./form-builder.app.coffee"

app.factory "Form", -> class
  constructor: (@name, @model) ->
    @fields = []

  addField: (name, opts) -> @fields.push _.extend name: name, opts

app.provider "FormConfig", ->
  config = {}

  set: (k, v) ->
    config[k] = v
  $get: ->
    get: (k) -> config[k]
