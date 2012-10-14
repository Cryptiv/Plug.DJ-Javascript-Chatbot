class uservoiceCommand extends Command
	init: ->
		@command=''
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = 'Have an idea for the room, our bot, or an event?  Awesome! Submit it to our uservoice and we\'ll get started on it: http://is.gd/IzP4bA'
		msg += ' (please don\'t ask for mod)'
		API.sendChat(msg)
