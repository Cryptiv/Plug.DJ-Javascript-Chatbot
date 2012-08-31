class badQualityCommand extends Command
	init: ->
		@command='.128'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		msg = "Flagged for bad sound quality. Where do you get your music? The garbage can? Don't play this low quality tune again!"
		API.sendChat msg