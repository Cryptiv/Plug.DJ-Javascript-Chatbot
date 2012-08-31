class RoomHelper
	lookupUser: (username)->
		for id,u of data.users
			if u.getUser().username == username
				return u.getUser()
		return false

	userVoteRatio: (user)->
		console.log "vote log pull for "+user.username+":",data.voteLog[user.id]
		songVotes = data.voteLog[user.id]
		votes = {
			'woot':0,
			'meh':0
		}
		for songId, vote of songVotes
			if vote == 1
				votes['woot']++
			else if vote == -1
				votes['meh']++
		votes['positiveRatio'] = (votes['woot'] / (votes['woot']+votes['meh'])).toFixed(2)
		votes
		

	# roomVoteRatio: ->
	# 	# ..