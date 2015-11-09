_ = require "lodash"
app = require "./form-builder.app.coffee"

getElementType = (value) -> Object::toString.call(value).replace(/^.*\s(\w+)\]$/, "$1").toLowerCase()
getElement = (element) -> angular.element element
setAttrs = (el, attrs...) -> el.attr _.extend {}, attrs...
decorateElement = (el, decorators...) ->
  if decorator = _.last _.compact decorators then getElement(decorator).append el else el

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

  compile: -> (scope, el, attrs) ->
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
    formElement = decorateElement getElement(formTpl), FormConfig.get "formDecorator", form.decorator
    el.append $compile(formElement) scope
    setAttrs el.find("form"), FormConfig.get("formAttrs"), form.attrs
]

app.directive "formElement", ["$compile", "FormConfig", ($compile, FormConfig) ->
  restrict: "E"
  compile: -> (scope, el) ->
    element = scope.element
    label = element.label
    name = element.name
    id = "form-#{scope.formName}-#{name}"
    config = FormConfig.get()

    if label
      labelElement = getElement "<label for=\"#{id}\">"
      labelElement.html label
      setAttrs labelElement, config.labelAttrs, element.labelAttrs
      el.append labelElement

    scope.model[name] ||= element.init
    value = scope.model[name]
    widget = getElement elementTypes[ element.type || getElementType(value) ] or elementTypes.string
    widget.attr
      "ng-model": "model.#{name}"
      id: id

    setAttrs widget, config.widgetAttrs, element.attrs
    el.append $compile(widget) scope
]

app.directive "formButton", ["$compile", "FormConfig", ($compile, FormConfig) ->
  restrict: "E"
  compile: -> (scope, el, attrs) ->
    config = FormConfig.get()
    button = scope.button
    buttonElement = getElement "<button>"
    setAttrs buttonElement, config.buttonAttrs, button.attrs
    buttonElement.html button.label
    el.append $compile(buttonElement) scope
]
