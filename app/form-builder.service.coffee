_ = require "lodash"
app = require "./form-builder.app.coffee"

app.factory "Form", ["FormConfig", (FormConfig) -> class
  constructor: (@name, @model) ->
    @fields = []
    @buttons = [
      label: FormConfig.getDefaultButtonLabel()
      attrs:
        type: "submit"
    ]

  addField: (name, opts) -> @fields.push _.extend name: name, opts
]

app.provider "FormConfig", ->
  config =
    defaultButtonLabel: "submit"

  set: (k, v) ->
    config[k] = v
  $get: ->
    get: (k) -> if k then config[k] else config
    getDefaultButtonLabel: -> config.defaultButtonLabel
