class resetAfkCommand extends Command
	init: ->
		@command='/resetafk'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		if @msgData.message.length > 10
			name = @msgData.message.substring(11)#remove @
			for id,u of data.users
				if u.getUser().username == name
					u.updateActivity()
					API.sendChat '@' + u.getUser().username + '\'s AFK time has been reset.'
					return
			API.sendChat 'Not sure who ' + name + ' is'
			return
		else
			API.sendChat 'Yo Gimme a name r-tard'
			return