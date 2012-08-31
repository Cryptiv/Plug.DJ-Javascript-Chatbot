class unhookCommand extends Command
	init: ->
		@command='/unhook events all'
		@parseType='exact'
		@rankPrivelege='host'

	functionality: ->
		API.sendChat 'Unhooking all events...'
		undoHooks()
		
