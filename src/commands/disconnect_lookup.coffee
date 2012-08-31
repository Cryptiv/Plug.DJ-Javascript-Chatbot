class disconnectLookupCommand extends Command
	init: ->
		@command='/dclookup'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		cmd = @msgData.message
		if cmd.length > 11#includes name
			givenName = cmd.slice(11)
			for id,u of data.users
				if u.getUser().username == givenName
					dcLookupId = id
					disconnectInstances = []
					for dcUser in data.userDisconnectLog
						if dcUser.id == dcLookupId
							disconnectInstances.push(dcUser)
					if disconnectInstances.length > 0
						resp = u.getUser().username + ' has disconnected ' + disconnectInstances.length.toString() + ' time'
						if disconnectInstances.length == 1#lol plurals
							resp += '. '
						else
							resp += 's. '
						recentDisconnect = disconnectInstances.pop()
						dcHour = recentDisconnect.time.getHours()
						dcMins = recentDisconnect.time.getMinutes()
						if dcMins < 10
							dcMins = '0' + dcMins.toString()
						dcMeridian = if (dcHour % 12 == dcHour) then 'AM' else 'PM'
						dcTimeStr = ''+dcHour+':'+dcMins+' '+dcMeridian
						dcSongsAgo = data.songCount - recentDisconnect.songCount
						resp += 'Their most recent disconnect was at ' + dcTimeStr + ' (' + dcSongsAgo + ' songs ago). '

						if recentDisconnect.waitlistPosition != undefined
							resp += 'They were ' + recentDisconnect.waitlistPosition + ' song'
							if recentDisconnect.waitlistPosition > 1#lol plural
								resp += 's'
							resp += ' away from the DJ booth.'
						else
							resp += 'They were not on the waitlist.'
						API.sendChat resp
						return
					else
						API.sendChat "I haven't seen " + u.getUser().username + " disconnect."
						return
			API.sendChat "I don't see a user in the room named '"+givenName+"'."