class tableFixCommand extends Command
	init: ->
		@command='/tablefix'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat " ┬─┬ノ( º _ ºノ)"
