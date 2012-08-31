class whyWootCommand extends Command
	init: ->
		@command='/whywoot'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "We dislike AFK djs. We calculate your AFK status by checking the last time you
			Woot'd or spoke. If you don't woot, I'll automagically remove you. Use our AutoWoot
			script to avoid being removed: http://bit.ly/McZdWw"

		if((nameIndex = @msgData.message.indexOf('@')) != -1)
			API.sendChat @msgData.message.substr(nameIndex) + ', ' + msg
		else
			API.sendChat msg