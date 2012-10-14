class unlockCommand extends Command
	init: ->
		@command='/unlock'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		'You\'ll never get the key to unlock my heart'
		data.unlockBooth()
