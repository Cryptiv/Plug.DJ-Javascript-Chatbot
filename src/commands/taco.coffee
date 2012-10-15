class tacoCommand extends Command
	init: ->
		@command='pizza'
		@parseType='startsWith'
		@rankPrivelege='user'

	randomTaco: ->
		tacos = [
				"cheese pizza",
				"pepperoni pizza",
				"hawaiian pizza",
				"BBQ chicken pizza",
				"anchovies pizza",
				"DNCH turkey pizza",
				"Adam's pepperoni pizza",
				"vegan pizza"
			];
		t = Math.floor Math.random()*tacos.length
		return tacos[t]

	functionality: ->
		msg = @msgData.message
		r = new RoomHelper()
		if msg.length > 6 #includes username
			name = msg.substr(6)
			user = r.lookupUser name
			if user == false
				API.sendChat "/em doesn't see '"+name+"' in room and eats pizza himself"
				return false
			else
				API.sendChat "@"+user.username+", @"+@msgData.from+" has given you some "+@randomTaco()+"."