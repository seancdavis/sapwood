class App.Components.CodeEditor extends Backbone.View

  el: 'body'

  initialize: (options) ->
    CodeMirror.fromTextArea($(options.textarea)[0],
      keyMap: 'sublime'
      mode:
        name: 'javascript'
        json: true
      lineNumbers: true
      viewportMargin: Infinity
      tabSize: 2
      autofocus: true
      extraKeys:
        "Tab": (cm) ->
          cm.replaceSelection("   " , "end")
    )
