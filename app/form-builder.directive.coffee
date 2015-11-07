_ = require "lodash"
app = require "./form-builder.app.coffee"

getElementType = (value) -> Object::toString.call(value).replace(/^.*\s(\w+)\]$/, "$1").toLowerCase()

app.directive "formBuilder", [ ->
  restrict: "E"
  scope:
    object: "="
    submit: "="

  template: """
    <form novalidate ng-submit="submit()">
      <form-element ng-repeat="element in elements"></form-element>
    </form>
  """

  compile: (tElem, tAttrs) -> (scope, el, attrs) ->
    scope.submit ||= ->
    scope.elements = _.map scope.object, (obj) ->
      label: obj
      type: getElementType obj
]

elementTypes =
  string: "<input>"
  number: "<input>"

setElementAttrsByType = (el, type) ->
  switch type
    when "string"
      el.attr type: "text"

    when "number"
      el.attr type: "number"

app.directive "formElement", [ ->
  restrict: "E"
  compile: (tElem, tAttr) -> (scope, el, attrs) ->
    type = scope.element.type
    formElement = angular.element elementTypes[type]
    setElementAttrsByType formElement, type
    el.append formElement
]
