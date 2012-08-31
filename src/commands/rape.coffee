class rapeCommand extends Command
	init: ->
		@command='rapes pup'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat "slaps @" + @msgData['from']
