class punishCommand extends Command
	init: ->
		@command='punish'
		@parseType='startsWith'
		@rankPrivelege='mod'

	getPunishment: (username)->
		punishments=[
			"/me rubs sandpaper on @{victim}'s scrotum"
			"/me pokes @{victim} in the eyes"
			"/me throws sand in @{victim}'s eyes"
			"/me makes @{victim}'s mother cry"
			"/me penetrates @{victim} with a sharpie"
			"/me pinches @{victim}'s nipples super hard"
			"/me gives @{victim} a wet willy"
			"/me pulls @{victim}'s hair out"
			"/me gives @{victim} a paper cut"
			"/me  ties @{victim} at the ankles with skipping rope and hangs him upside down over an audience of wild boars in heat."
		]
		p = Math.floor Math.random()*punishments.length
		punishment = punishments[p].replace('{victim}',username)
		punishment

	functionality: ->
		msg = @msgData.message
		r = new RoomHelper()
		if msg.length > 8 #username
			name = msg.substr(8)
			user = r.lookupUser name
			if user == false
				API.sendChat "/me punishes @"+@msgData.from+" for getting the syntax wrong."
				setTimeout(->
					API.sendChat "Seriously though, I don't recognize the username '"+name+"'",
				750)
			else
				if user.owner
					API.sendChat @getPunishment @msgData.from
				else
					API.sendChat @getPunishment(user.username)