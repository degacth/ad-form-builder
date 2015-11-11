_ = require "lodash"
app = require "./form-builder.app.coffee"

app.factory "Form", ["FormConfig", (FormConfig) -> class
  buttonsAfter: yes

  constructor: (@name, @model) ->
    @attrs = {}
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
    buttonsAfter: yes

  set: (k, v) ->
    unless v then return _.extend config, k
    config[k] = v

  $get: ->
    get: (k) -> if k then config[k] else config
    getDefaultButtonLabel: -> config.defaultButtonLabel
