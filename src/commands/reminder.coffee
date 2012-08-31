class reminderCommand extends Command
	init: ->
		@command='/reminder'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		cmd = @msgData.message
		if cmd.length>10
			params = cmd.slice(10)
			cmdPatt = /^"(.+)"\s(\d)$/
			reminderParams = cmdPatt.exec(params)
			if reminderParams? and reminderParams.length == 3
				reminder = {
					songCount : parseInt(reminderParams[2])+data.songCount
					msg : reminderParams[1]
				}
				data.reminders.push reminder
				API.sendChat "Ok I'm going to say '"+reminderParams[1]+"' in "+reminderParams[2]+" songs."
			else
				API.sendChat "look at that poopy ass syntax right there"
				console.log cmd,cmdPatt,reminderParams
		else
			API.sendChat "ur syntax is just plain poopy"
		
