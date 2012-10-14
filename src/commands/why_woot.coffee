class whyWootCommand extends Command
	init: ->
		@command='/whywoot'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "It's nice and you get points."

		if((nameIndex = @msgData.message.indexOf('@')) != -1)
			API.sendChat @msgData.message.substr(nameIndex) + ', ' + msg
		else
			API.sendChat msg