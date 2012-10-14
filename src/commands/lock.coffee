class lockCommand extends Command
	init: ->
		@command='/lock'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		'Pop and lock dat ish'
		data.lockBooth()
