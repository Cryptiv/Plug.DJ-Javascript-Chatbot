class swapCommand extends Command
	init: ->
		@command='/swap'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		msg = @msgData.message
		swapRegex = new RegExp("^/swap @(.+) for @(.+)$")
		users = swapRegex.exec(msg).slice(1)
		r = new RoomHelper()
		if users.length == 2
			userRemove = r.lookupUser users[0]
			userAdd = r.lookupUser users[1]
			if userRemove == false or userAdd == false
				API.sendChat 'Error parsing one or both names'
				console.log 'Err users',users,userRemove,userAdd
				return false
			else
				data.lockBooth(->
					API.moderateRemoveDJ userRemove.id
					API.sendChat "Removing " + userRemove.username + "..."
					setTimeout(->
						API.moderateAddDJ userAdd.id
						API.sendChat "Adding " + userAdd.username + "..."
						setTimeout(->
							data.unlockBooth()
						,1500)
					,1500)
				)
		else
			API.sendChat "Command didn't parse into two seperate usernames"