class dieCommand extends Command
	init: ->
		@command='/die'
		@parseType='exact'
		@rankPrivelege='host'

	functionality: ->
		API.sendChat 'Unhooking Events...'
		undoHooks()
		API.sendChat 'Deleting bot data...'
		data.implode()
		API.sendChat 'Consider me dead'
