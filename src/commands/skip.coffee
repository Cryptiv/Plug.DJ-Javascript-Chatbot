class skipCommand extends Command
	init: ->
		@command='/skip'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		API.moderateForceSkip()
		
