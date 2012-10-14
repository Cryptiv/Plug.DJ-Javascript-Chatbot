class rulesCommand extends Command
	init: ->
		@command='/rules'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "1) Be kind. No trolling. "
		msg += "2) Be open minded. Avoid racism and homophobia. "
		msg += "3) Be respectful towards everyone including mods. "
		msg += "4) Let your votes do the talking."
		API.sendChat(msg)
		
