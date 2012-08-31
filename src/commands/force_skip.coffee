class forceSkipCommand extends Command
	init: ->
		@command='/forceskip'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		msg = @msgData.message
		if msg.length > 11 #command switch included
			param = msg.substr(11)
			if param == 'enable'
				data.forceSkip = true
				API.sendChat "Forced skipping enabled."
			else if param == 'disable'
				data.forceSkip = false
				API.sendChat "Forced skipping disabled."
		