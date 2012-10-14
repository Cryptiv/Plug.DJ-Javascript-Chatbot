class sourceCommand extends Command
	init: ->
		@command=['/source', '/sourcecode', '/author']
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = 'Originally Backus wrote me in CoffeeScript. I was edited/updated by INDIE+'
		API.sendChat msg