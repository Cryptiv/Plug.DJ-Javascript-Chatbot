class hugCommand extends Command
	init: ->
		@command='hugs bot'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat "hugs @" + @msgData['from']
