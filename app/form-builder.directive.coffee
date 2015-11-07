_ = require "lodash"
app = require "./form-builder.app.coffee"

getElementType = (value) -> Object::toString.call(value).replace(/^.*\s(\w+)\]$/, "$1").toLowerCase()

getElement = (element) -> angular.element element

elementTypes =
  string: "<input type=\"text\">"
  number: "<input type=\"number\">"
  choice: "<select name=\"{{element.name}}\" ng-options=\"v for v in element.choices\">"
  boolean: "<input type=\"checkbox\">"

setElementAttrsByType = (el, type) ->
  switch type
    when "string"
      el.attr type: "text"

    when "number"
      el.attr type: "number"

    when "boolean"
      el.attr type: "checkbox"

    when "array"
      el.attr
        "ng-options": "v for v in model.array"
        "multiple": true

app.directive "formBuilder", [ ->
  restrict: "E"
  scope:
    submit: "="
    form: "="

  template: """
    <form novalidate ng-submit="submit()" name="{{ formName }}">
      <form-element ng-repeat="element in elements"></form-element>
    </form>
  """

  compile: (tElem, tAttrs) -> (scope, el, attrs) ->
    scope.submit ||= ->
    form = scope.form
    scope.model = form.model
    scope.elements = form.fields
    scope.formName = form.name
]

app.directive "formElement", ["$compile", ($compile) ->
  restrict: "E"
  compile: (tElem, tAttr) -> (scope, el, attrs) ->
    element = scope.element
    label = element.label
    name = element.name
    id = "form-#{scope.formName}-#{name}"
    if label then el.append (getElement "<label for=\"#{id}\">").text label
    scope.model[name] ||= element.init
    value = scope.model[name]
    widget = getElement elementTypes[ element.type || getElementType(value) || "string" ]
    widget.attr
      "ng-model": "model.#{name}"
      id: id
    el.append $compile(widget) scope
]
