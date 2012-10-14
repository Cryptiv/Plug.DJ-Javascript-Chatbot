class themeCommand extends Command
	init: ->
		@command='/theme'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "We play primarily Indie Rock, Pop, Folk and Electronic but ALL GENRES ARE ALWAYS WELCOME. "
		msg += "Subject to votes of disapproval of course."
		API.sendChat(msg)
