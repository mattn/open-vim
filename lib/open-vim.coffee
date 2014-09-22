{exec, child} = require 'child_process'

module.exports =

  activate: (state) ->
    atom.workspaceView.command "open-vim:open", => @open()

  open: ->
    exec "which gvim", (error, stdout, stderr) ->
      if error
        alert("gvim not found")
      editor = atom.workspace.getActivePaneItem()
      filePath = editor?.buffer.file?.path
      if filePath
        exec "gvim --remote-silent #{filePath}"
