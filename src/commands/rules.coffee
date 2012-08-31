class rulesCommand extends Command
	init: ->
		@command='/rules'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "1) Play good sound quality music. "
		msg += "2) Don't replay a song on the room history. 3) Max song limit 8 minutes. "
		msg += "4) DO NOT GO AWAY FROM KEYBOARD ON DECK! Please WOOT on DJ Booth and respect your fellow DJs!"
		API.sendChat(msg)
		
