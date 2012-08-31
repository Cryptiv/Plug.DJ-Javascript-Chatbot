class voteRatioCommand extends Command
	init: ->
		@command='/voteratio'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		r = new RoomHelper()
		msg = @msgData.message
		if msg.length == 10
			console.log "bitches want room ratio"
			#r.roomVoteRatio()
		else if msg.length > 12 #includes username
			name = msg.substr(12)
			u = r.lookupUser(name)
			if u != false
				votes = r.userVoteRatio(u)
				console.log u.username + ' votes:',votes
				msg = u.username + " has wooted "+votes['woot'].toString()+" time"
				if votes['woot'] == 1
					msg+=', '
				else
					msg+='s, '
				msg += "and meh'd "+votes['meh'].toString()+" time"
				if votes['meh'] == 1
					msg+='. '
				else
					msg+='s. '
				msg+="Their woot:vote ratio is " + votes['positiveRatio'].toString() + "."
				API.sendChat msg
			else
				API.sendChat "I don't recognize a user named '"+name+"'"
		else
			API.sendChat "I'm not sure what you want from me..."
		
