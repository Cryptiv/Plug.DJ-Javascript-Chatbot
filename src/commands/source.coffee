class sourceCommand extends Command
	init: ->
		@command=['/source', '/sourcecode', '/author']
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = 'Backus wrote me in CoffeeScript.  A generalized version of me should be available on github soon!'
		API.sendChat msg