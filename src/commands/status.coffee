class statusCommand extends Command
	init: ->
		@command='/status'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		lt = data.launchTime
		month = lt.getMonth()+1
		day = lt.getDate()
		hour = lt.getHours()
		meridian = if (hour % 12 == hour) then 'AM' else 'PM'
		min = lt.getMinutes()
		min = if (min < 10) then '0'+min else min

		t = data.totalVotingData
		t['songs'] = data.songCount

		launch = 'Initiated ' + month + '/' + day + ' ' + hour + ':' + min + ' ' + meridian + '. '
		totals = '' + t.songs + ' songs have been played, accumulating ' + t.woots + ' woots, ' + t.mehs + ' mehs, and ' + t.curates + ' queues.'
		
		msg = launch + totals

		API.sendChat msg