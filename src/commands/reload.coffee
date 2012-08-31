class reloadCommand extends Command
	init: ->
		@command='/reload'
		@parseType='exact'
		@rankPrivelege='host'

	functionality: ->
		API.sendChat 'brb'
		undoHooks()
		pupSrc = data.pupScriptUrl
		data.implode()
		$.getScript(pupSrc)