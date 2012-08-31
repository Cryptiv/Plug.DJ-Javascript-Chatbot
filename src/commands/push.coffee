class pushCommand extends Command
	init: ->
		@command='/push'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		msg = @msgData.message
		if msg.length>@command.length+2#'/push @'
			name = msg.substr(@command.length+2)
			r = new RoomHelper()
			user = r.lookupUser(name)
			if user != false
				API.moderateAddDJ user.id
				console.log "Adding User to DJ booth", user
			else
				console.log "could not find user with name "+name