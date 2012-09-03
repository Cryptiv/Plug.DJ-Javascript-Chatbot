class User

	afkWarningCount: 0#0:hasnt been warned, 1: one warning etc.
	lastWarning: null
	protected: false #if true pup will refuse to kick
	isInRoom: true#by default online

	constructor: (@user)->
		@init()

	init: =>
		@lastActivity = new Date()

	updateActivity: =>
		@lastActivity = new Date()
		@afkWarningCount = 0
		@lastWarning = null

	getLastActivity: =>
		return @lastActivity

	getLastWarning: =>
		if @lastWarning == null
			return false
		else
			return @lastWarning

	getUser: =>
		return @user

	getWarningCount: =>
		return @afkWarningCount

	getIsDj: =>
		DJs = API.getDJs()
		for dj in DJs
			if @user.id == dj.id
				return true
		return false

	warn: =>
		@afkWarningCount++
		@lastWarning = new Date()

	notDj: =>
		@afkWarningCount = 0
		@lastWarning = null

	inRoom: (online)=>
		@isInRoom = online

	updateVote: (v)=>
		if @isInRoom
			data.voteLog[@user.id][data.currentsong.id] = v