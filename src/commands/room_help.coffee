class roomHelpCommand extends Command
	init: ->
		@command='/roomhelp'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg1 = "Welcome to the Dubstep Den! Create a playlist and populate it with songs from either YouTube or Soundcloud.  "
		msg1+= "Click the 'Join Waitlist' button and wait your turn to play music. Most electronic music allowed, type '/theme' for specifics."

		msg2 = "Stay active while waiting to play your song or I'll remove you.  Play good quality music that hasn't been played recently (check room history).  "
		msg2+= "Avoid over played artists like Skrillex. Ask a mod if you're unsure about your song choice"
		API.sendChat(msg1)
		setTimeout (-> API.sendChat msg2), 750
		
