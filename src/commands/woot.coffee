class wootCommand extends Command
	init: ->
		@command='/woot'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "DANCE!"
		if((nameIndex = @msgData.message.indexOf('@')) != -1)
			API.sendChat @msgData.message.substr(nameIndex) + ', ' + msg
		else
			API.sendChat msg