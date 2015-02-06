{exec, child} = require 'child_process'

module.exports =

  activate: (state) ->
    atom.workspaceView.command "open-vim:open", => @open()

  open: ->
    exec "uname -s", (error, stdout, sterr) ->
      if error
        alert("operating system could not be detected")
      else
        if stdout
          # Mac
          if stdout.indexOf("Darwin") isnt -1
            exec "which mvim", (error, stdout, stderr) ->
              if error
                alert("mvim not found")
              editor = atom.workspace.getActivePaneItem()
              filePath = editor?.buffer.file?.path
              if filePath
                exec "mvim --remote-silent #{filePath}"
  
          # Linux  
          else if stdout.indexOf("Linux") isnt -1
            exec "which gvim", (error, stdout, stderr) ->
              if error
                alert("gvim not found")
              editor = atom.workspace.getActivePaneItem()
              filePath = editor?.buffer.file?.path
              if filePath
                exec "gvim --remote-silent #{filePath}"
          else
            alert("operating system not supported")
        else
          alert("operating system could not be detected")
