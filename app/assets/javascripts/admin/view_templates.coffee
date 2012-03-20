window.onload = ->
  editor = ace.edit("editor")
  RubyMode = require("ace/mode/ruby").Mode
  editor.setTheme "ace/theme/vibrant_ink"
  editor.getSession().setMode new RubyMode()
  editor.setShowPrintMargin(false)
  editor.getSession().setUseWrapMode(true);

  textarea = $("textarea[name=\"view_template[contents]\"]").hide()
  editor.getSession().setValue textarea.val()
  editor.getSession().on "change", ->
    textarea.val editor.getSession().getValue()