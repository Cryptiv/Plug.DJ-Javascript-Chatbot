class tacoCommand extends Command
	init: ->
		@command='taco'
		@parseType='startsWith'
		@rankPrivelege='user'

	randomTaco: ->
		tacos = [
				"Mexican Pizza",
				"Chicken Soft Taco",
				"Double Decker Taco",
				"Volcano Taco Supreme",
				"Crunchy Taco Supreme",
				"Grilled Steak Soft Taco",
				"Cheesy Gordita Crunch",
				"Doritos Locos Taco"
			];
		r = Math.floor Math.random()*tacos.length
		return tacos[r]

	functionality: ->
        msg = @msgData.message
        taco = @randomTaco()
        if(msg.substring(5, 6) == "@")
	        tacoName = msg.substring(6)
	        if tacoName == '#Wolf Pup'
	        	API.sendChat "No thanks I'll get fat :("
	        else
	        	API.sendChat "Yo @" + tacoName + ", " + @msgData.from + " just gave you a " + taco + "!"
        else
	        API.sendChat "Yo @" + @msgData.from + ", here is your " + taco + "!"
