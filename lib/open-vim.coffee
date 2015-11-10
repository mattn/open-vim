{execFile, child} = require 'child_process'
OS                = require 'os'

module.exports =

  config:
    executablePath:
      type: "string"
      default: ""

  activate: (state) ->
    vimPath = atom.config.get "open-vim.executablePath"
    if !!vimPath
      @commands = atom.commands.add "atom-workspace",
        "open-vim:open": => @open(vimPath)
      @open(vimPath) # call explicitly upon activate, since package is lazy loaded and this setup is async
      return

    vimType = if OS.platform() is "darwin" then "mvim" else "gvim"
    whichType = if OS.platform() is "win32" then "where" else "which"
    execFile whichType, [vimType], (error, stdout, stderr) =>
      if error
        alert "#{vimType} not found, make sure you started atom from the terminal and that #{vimType} is on the PATH"
      else
        @commands = atom.commands.add "atom-workspace",
          "open-vim:open": => @open(vimType)
        @open(vimType) # call explicitly upon activate, since package is lazy loaded and this setup is async

  open: (vimType) ->
    editor = atom.workspace.getActiveTextEditor()
    if editor
      filePath = editor.getPath()
      lineNum  = editor.bufferPositionForScreenPosition(editor.getCursorScreenPosition()).row + 1 # +1 to get actual line
      execFile vimType, ["--remote-silent", "+#{lineNum}", filePath], (error, stdout, stderr) ->
        if error
          atom.notifications.addError error.message

  deactivate: ->
    @commands.dispose() if @commands
