class tableFlipCommand extends Command
	init: ->
		@command='/tableflip'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat "(╯°□°）╯︵ ┻━┻"
