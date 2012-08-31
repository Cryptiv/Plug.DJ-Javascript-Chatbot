class allAfksCommand extends Command
	init: ->
		@command='/allafks'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = ''
		usrs = API.getUsers() 
		for u in usrs
			now = new Date()
			uAfk = now.getTime() - data.users[u.id].getLastActivity().getTime()
			if uAfk > (10*60*1000)#AFK longer than 10 minutes
				#creat afk string
				if msToStr(uAfk) != false
					msg += u.username + ' - ' + msToStr(uAfk)
					msg += '. '

		if msg == ''
			API.sendChat "No one is AFK"
		else
			API.sendChat 'AFKs: ' + msg