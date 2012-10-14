class overplayedCommand extends Command
	init: ->
		@command=''
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat "View the list of songs we consider overplayed and suggest additions at http://den.johnback.us/overplayed_tracks"
		
