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
		if msg.length > 8 #includes username
			user = r.lookupUser(msg.substr(8))
			if user == false
				API.sendChat "/em doesn't see '"+msg.substr(8)+"' in room and eats pizza himself"
				return false
			else
				API.sendChat "@"+user.username+", @"+@msgData.from+" has rewarded you with some "+@randomTaco()+"."