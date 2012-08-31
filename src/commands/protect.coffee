class protectCommand extends Command
	init: ->
		@command='/protect'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		msg = @msgData.message
		if msg.length > 9 #includes arg
			username = msg.substring(10)
			for id,user of data.users
				if user.getUser().username == username
					user.protected = true
					API.sendChat "I shall protect you @"+username+" (I just wont kick you)"
					return
		API.sendChat "That aint no name I ever did see"
		return
		
