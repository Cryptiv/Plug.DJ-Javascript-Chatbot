class hugCommand extends Command
	init: ->
		@command='hugs pup'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat "hugs @" + @msgData['from']
