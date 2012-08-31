class themeCommand extends Command
	init: ->
		@command='/theme'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "Any type of Bass Music is allowed here. Including Dubstep, Complextro, Drum and Bass, "
		msg += "Garage, Breakbeat, Hardstyle, Moombahton, HEAVY EDM, House, Electro, and Trance!!"
		API.sendChat(msg)
