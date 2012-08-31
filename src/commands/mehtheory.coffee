class whyMehCommand extends Command
	init: ->
		@command='/whymeh'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = "Reserve Mehs for songs that are a) extremely overplayed b) off genre c) absolutely god awful or d) troll songs. "
		msg += "If you simply aren't feeling a song, then remain neutral"
		API.sendChat msg