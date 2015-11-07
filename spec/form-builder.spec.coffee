describe "Элемент базовой формы", ->
  compile = null
  scope = null
  form = null
  formDirective = "<form-builder submit=\"submit\" form=\"form\"></form-builder>"
  compiler = ->
    el = compile(formDirective) scope
    do scope.$digest
    el

  beforeEach angular.mock.module "FormBuilder"
  beforeEach inject ($compile, $rootScope, Form) ->
    compile = $compile
    scope = $rootScope
    form = new Form "test-form", null
    scope.form = form

  describe "Когда директива формы скомпилирована", ->
    it "Должна содержать элемент формы, submit, model", ->
      noop = ->
      model = {}
      scope.submit = noop
      form.model = model
      el = compiler()

      expect(el.find("form[name=test-form]").length).toBe 1
      expect(el.find("form").scope().model).toBe(model)
      expect(el.find("form").scope().submit).toBe(noop)

    it "Должна содержать элементы формы", ->
      form.addField "hello",
        label: "Здрасте"
        init: "world"
      form.addField "world",
        label: "Мир"
        init: 1
      form.addField "foo",
        label: "Фу"
        type: "boolean"

      form.model = world: 2
      el = compiler()

      expect(el.find("input").length).toBe(3)
      expect(el.find("label").length).toBe(3)
      expect(el.find("input[type=number]").length).toBe(1)
      expect(el.find("input[type=text]").length).toBe(1)
      expect(el.find("input[type=checkbox]").length).toBe(1)
      expect(el.find("input[ng-model]").length).toBe(3)

    it "Должна связывать модели", ->
      model = foo: "bar"
      form.model = model
      el = compiler()

      dirScope = el.find("form").scope()
      expect(dirScope.model.foo).toBe(model.foo)

      dirScope.model.foo = "foo"
      expect(model.foo).toBe("foo")

    it "Должна реализовывать select", ->
      model = hello: "world"
      form.model = model
      form.addField "hello",
        label: "Здрасте"
        type: "choice"
        choices: ["hello", "world"]

      el = compiler()
      expect(el.find("select").length).toBe(1)
      expect(el.find("option").length).toBe(2)
