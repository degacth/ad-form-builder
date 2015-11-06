app = require "./form-builder.app.coffee"

app.directive "formBuilder", ->
  restrict: "EA"
  scope:
    object: "="
    submit: "="

  template: "<form novalidate ng-submit=\"submit()\"></form>"
  compile: (tElem, tAttrs) -> (scope, el, attrs) ->
    scope.submit ||= ->

