class avgVoteRatioCommand extends Command
	init: ->
		@command='/avgvoteratio'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		roomRatios = []
		r = new RoomHelper()
		for uid, votes of data.voteLog
			user = data.users[uid].getUser()
			userRatio = r.userVoteRatio(user)
			roomRatios.push userRatio['positiveRatio']
		averageRatio = 0.0
		for ratio in roomRatios
			averageRatio+=ratio
		averageRatio = averageRatio / roomRatios.length
		msg = "Accounting for " + roomRatios.length.toString() + " user ratios, the average room ratio is " + averageRatio.toFixed(2).toString() + "."
		API.sendChat msg
		
		