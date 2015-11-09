_ = require "lodash"
app = require "./form-builder.app.coffee"

getElementType = (value) -> Object::toString.call(value).replace(/^.*\s(\w+)\]$/, "$1").toLowerCase()
getElement = (element) -> angular.element element
setAttrsToElement = (el, attrs = {}) -> el.attr attrs
setAttrsByType = (el, config, type) -> setAttrsToElement el, if type then config["#{type}Attrs"] else config

elementTypes =
  string: "<input type=\"text\">"
  number: "<input type=\"number\">"
  choice: "<select name=\"{{element.name}}\" ng-options=\"v for v in element.choices\">"
  boolean: "<input type=\"checkbox\">"

app.directive "formBuilder", ["$compile", "FormConfig", ($compile, FormConfig) ->
  restrict: "E"
  scope:
    submit: "="
    form: "="

  compile: (tElem, tAttrs) -> (scope, el, attrs) ->
    formTpl = """
      <form novalidate ng-submit="submit()" name="{{ formName }}">
        <form-element ng-repeat="element in elements"></form-element>
        <form-button ng-repeat="button in buttons"></form-button>
      </form>
    """

    scope.submit ||= ->
    form = scope.form
    scope.model = form.model || {}
    scope.elements = form.fields
    scope.buttons = form.buttons
    scope.formName = form.name
    formElement = getElement formTpl

    if formDecorator = FormConfig.get "formDecorator"
      formElement = getElement(formDecorator).append formElement

    el.append $compile(formElement) scope

    setAttrsByType el.find("form"), FormConfig.get(), "form"
]

app.directive "formElement", ["$compile", "FormConfig", ($compile, FormConfig) ->
  restrict: "E"
  compile: (tElem, tAttr) -> (scope, el) ->
    element = scope.element
    label = element.label
    name = element.name
    id = "form-#{scope.formName}-#{name}"
    config = FormConfig.get()

    if label
      labelElement = getElement "<label for=\"#{id}\">"
      labelElement.html label
      setAttrsByType labelElement, config, "label"
      el.append labelElement

    scope.model[name] ||= element.init
    value = scope.model[name]
    widget = getElement elementTypes[ element.type || getElementType(value) ] or elementTypes.string
    widget.attr
      "ng-model": "model.#{name}"
      id: id

    setAttrsByType widget, config, "widget"
    el.append $compile(widget) scope
]

app.directive "formButton", ["$compile", ($compile) ->
  restrict: "E"
  compile: (tElem, tAttr) -> (scope, el, attrs) ->
    button = scope.button
    buttonElement = getElement "<button>"
    setAttrsByType buttonElement, button.attrs
    buttonElement.html button.label
    el.append $compile(buttonElement) scope
]
