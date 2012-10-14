class roomHelpCommand extends Command
	init: ->
		@command='/roomhelp'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg1 = "Welcome to INDIE+! Create a playlist and populate it with songs from either YouTube, Soundcloud, or iTunes.  "
		msg1+= "Click the 'Join Waitlist/Click to DJ' button and wait your turn to play music. Type '/theme' for specific genres."

		msg2 = "Play good quality music that hasn't been played recently (check room history).  "
		msg2+= "Avoid over played artists. Ask a mod if you're unsure about your song choice"
		API.sendChat(msg1)
		setTimeout (-> API.sendChat msg2), 750
		
