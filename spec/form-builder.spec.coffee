describe "Элемент базовой формы", ->
  compile = null
  scope = null
  formDirective = "<form-builder submit=\"submit\" object=\"entity\"></form-builder>"
  compiler = ->
    el = compile(formDirective) scope
    do scope.$digest
    el

  beforeEach angular.mock.module "FormBuilder"
  beforeEach inject ($compile, $rootScope) ->
    compile = $compile
    scope = $rootScope

  describe "Когда компилируется директива", ->
    it "Должна содержать элемент формы", ->
      el = compiler()
      expect(el.find("form").length).toBe 1

    it "Должна содержать объект формы", ->
      scope.entity = {}
      el = compiler()
      expect(el.find("form").scope().object).toEqual({})

    it "Должна содержать функцию сохранения", ->
      scope.submit = ->
      el = compiler()
      expect(typeof el.find("form").scope().submit).toBe("function")

    it "Должна задавать функцию сохранения по умолчанию", ->
      el = compiler()
      expect(typeof el.find("form").scope().submit).toBe("function")
