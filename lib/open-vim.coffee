{exec, child} = require 'child_process'

module.exports =

  activate: (state) ->
    atom.workspaceView.command "open-vim:open", => @open()

  open: ->
    exec "uname -s", (error, stdout, stderr) ->
      if error
        alert "operating system could not be detected"
      else
        vimType = if stdout is "Darwin\n" then "mvim" else "gvim"

        exec "which #{vimType}", (error, stdout, stderr) ->
          if error
            alert "#{vimType} not found"
          editor = atom.workspace.getActivePaneItem()
          filePath = editor?.buffer.file?.path
          if filePath
            exec "#{vimType} --remote-silent #{filePath}"
