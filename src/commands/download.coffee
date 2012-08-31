class downloadCommand extends Command
	init: ->
		@command='/download'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		e = encodeURIComponent
		eAuthor = e(data.currentsong.author)
		eTitle = e(data.currentsong.title)
		msg ="Try this link for HIGH QUALITY DOWNLOAD: http://google.com/#hl=en&q="
		msg+=eAuthor + "%20-%20" + eTitle
		msg+="%20site%3Azippyshare.com%20OR%20site%3Asoundowl.com%20OR%20site%3Ahulkshare.com%20OR%20site%3Asoundcloud.com"

		API.sendChat(msg)
		
