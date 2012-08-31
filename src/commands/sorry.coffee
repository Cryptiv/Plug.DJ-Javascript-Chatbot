class saySorryCommand extends Command
	init: ->
		@command='/appologize'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		user = @msgData.from.toLowerCase()
		if(user=='backus' or user=='klaypex')
			API.sendChat "IM SORRY KLAYPEX! :("
