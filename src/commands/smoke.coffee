class smokeCommand extends Command
	init: ->
		@command=['/smokesesh','/smoke','/dab']
		@parseType='exact'
		@rankPrivelege='user'

	smoke: ->
		r = Math.floor Math.random()*@responses.length 
		return @responses[r]


	functionality: ->
		API.sendChat @smoke()

	responses: [
			"If we all had a bong we'd all get along.",
			"/me rolls a joint for you.",
			"Got anything to eat?",
			"Y-y-you're crazy....",
			"THE COLORS. THE FUCKIN COLORS!",
			"Everyone needs to give me a hug.",
			"Need to blaze til' my eyes glaze."
		]