class afksCommand extends Command
	init: ->
		@command='/afks'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = ''
		djs = API.getDJs() 
		for dj in djs
			now = new Date()
			djAfk = now.getTime() - data.users[dj.id].getLastActivity().getTime()
			if djAfk > (5*60*1000)#AFK longer than 5 minutes
				#creat afk string
				if msToStr(djAfk) != false
					msg += dj.username + ' - ' + msToStr(djAfk)
					msg += '. '

		if msg == ''
			API.sendChat "No one is AFK"
		else
			API.sendChat 'AFKs: ' + msg