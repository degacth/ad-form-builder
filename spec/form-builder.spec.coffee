describe "Элемент базовой формы", ->
  compile = null
  scope = null
  form = null
  config = null
  formDirective = "<form-builder submit=\"submit\" form=\"form\"></form-builder>"
  compiler = ->
    el = compile(formDirective) scope
    do scope.$digest
    el

  beforeEach angular.mock.module "FormBuilder", ["FormConfigProvider", (FormConfigProvider) ->
    FormConfigProvider.set
      formAttrs:
        class: "uk-form"
        "data-hello": "world"
      labelAttrs:
        class: "uk-label"
      formDecorator: "<div class=\"form-decor\">"
      elementsDecorator: "<div class=\"elements-decor\">"
      buttonsDecorator: "<div class=\"buttons-decor\">"
    return
  ]

  beforeEach inject ($compile, $rootScope, Form, FormConfig) ->
    compile = $compile
    scope = $rootScope
    form = new Form "test-form", null
    scope.form = form
    config = FormConfig.get()

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

    it "Должна реализовывать элементы на пустых параметрах", ->
      form.addField "hello"
      el = compiler()
      expect(el.find("form").length).toBe(1)
      expect(el.find("input[ng-model='model.hello']").length).toBe(1)

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
      expect(el.find("button[type=submit]").length).toBe(1)
      expect(el.find("button[type=submit]").text()).toBe("submit")

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

    it "Должна производить настройку атрибутов формы", ->
      form.addField "hello",
        label: "hello"
      el = compiler()
      expect(el.find("form.uk-form[data-hello=world]").length).toBe(1)
      expect(el.find("label.uk-label").length).toBe(1)

    it "Должна декорировать элементы на основе конфига", ->
      el = compiler()
      expect(el.find("div.form-decor").length).toBe(1)
      expect(el.find("div.elements-decor").length).toBe(1)
      expect(el.find("div.buttons-decor").length).toBe(1)

    it "Должна декорировать с переопеределением конфига", ->
      form.decorator = "<div class=\"new-form-decor\">"
      form.elementsDecorator = "<div class=\"new-elements-decor\">"
      form.buttonsDecorator = "<div class=\"new-buttons-decor\">"
      el = compiler()

      expect(el.find("div.new-form-decor").length).toBe(1)
      expect(el.find("div.new-elements-decor").length).toBe(1)
      expect(el.find("div.new-buttons-decor").length).toBe(1)

    it "Элементы формы вперёд кнопок", ->
      el = compiler()
      expect(el.find(".elements-decor").next().hasClass("buttons-decor")).toBe(true)

    it "Элементы формы после кнопок", ->
      config.buttonsAfter = false
      el = compiler()
      expect(el.find(".buttons-decor").next().hasClass("elements-decor")).toBe(true)
