class settings
	currentsong: {}
	users: {}
	djs: []
	mods: []
	host: []
	hasWarned: false
	currentwoots: 0
	currentmehs: 0
	currentcurates: 0
	internalWaitlist: []
	userDisconnectLog: []
	voteLog: {}
	seshOn: false
	forceSkip: false
	seshMembers: []
	launchTime: null
	totalVotingData:
		woots:0
		mehs:0
		curates:0
	pupScriptUrl: 'http://den.johnback.us/js/pup.js'
	afkTime: 12*60*1000#Time without activity to be considered afk. 12 minutes in milliseconds
	songIntervalMessages: [
		{interval:15,offset:0,msg:"/fb"}
		{interval:21,offset:0,msg:"Wondering what songs we consider overplayed? Learn more by typing /overplayed"}
		{interval:19,offset:0,msg:"Are you new to the den?  Type /roomhelp to get started."}
		{interval:17,offset:0,msg:"Wondering how the den's Power Users never get removed for being afk? Type /whywoot to find out"}
		{interval:23,offset:0,msg:"Theres a reason Justin Beiber isn't played here. We restrict songs to certain genres. Learn more by typing /theme"}
		{interval:50,offset:17,msg:"Fun fact: 0 of current and past moderators ASKED to be a moderator.  They earned it by being good users.  Shocking, I know."}
		{interval:100,offset:23,msg:"Did you miss our first Promoters Night?  Check out all the songs played that night here: http://goo.gl/fxEek"}
	]
	reminders: []#mod set reminders at various song intervals
	songCount: 0

	startup: =>
		@launchTime = new Date()

	newSong: ->
		@totalVotingData.woots += @currentwoots
		@totalVotingData.mehs += @currentmehs
		@totalVotingData.curates += @currentcurates

		@setInternalWaitlist()

		@reminderCheck()

		@currentsong = API.getMedia()
		if @currentsong != null
			return @currentsong
		else
			return false

	userJoin: (u)=>
		userIds = Object.keys(@users)
		if u.id in userIds
			@users[u.id].inRoom(true)
		else
			@users[u.id] = new User(u)
			@voteLog[u.id] = {}

	reminderCheck: =>
		i=0
		for reminder in @reminders
			console.log 'arr > item', @reminders,@reminders[i]
			i++
			# if @reminders[r]['songCount'] == @songCount
			# 	API.sendChat @reminders.splice(r,1)[0]['msg']

	setInternalWaitlist: =>
		boothWaitlist = API.getDJs().slice(1)#remove current dj
		lineWaitList = API.getWaitList()
		fullWaitList = boothWaitlist.concat(lineWaitList)
		@internalWaitlist = fullWaitList

	activity: (obj) ->
		if(obj.type == 'message')
			@users[obj.fromID].updateActivity()

	startAfkInterval: =>
		@afkInterval = setInterval(afkCheck,2000)

	intervalMessages: =>
		@songCount++
		for msg in @songIntervalMessages
			if ((@songCount+msg['offset']) % msg['interval']) == 0
				console.log msg['msg']
				API.sendChat msg['msg']
			else
				console.log msg
				console.log @songCount

	implode: =>
		for item,val of @
			if(typeof @[item] == 'object') 
				delete @[item]
		clearInterval(@afkInterval)

	lockBooth: (callback=null)->
		$.ajax({
		    url: "http://www.plug.dj/gateway/room.update_options",
		    type: 'POST',
		    data: JSON.stringify({
		        service: "room.update_options",
		        body: ["dubstep-den",{"boothLocked":true,"waitListEnabled":true,"maxPlays":1,"maxDJs":5}]
		    }),
		    async: this.async,
		    dataType: 'json',
		    contentType: 'application/json'
		}).done(->
			if callback?
				callback()
			)

	unlockBooth: (callback=null)->
		$.ajax({
		    url: "http://www.plug.dj/gateway/room.update_options",
		    type: 'POST',
		    data: JSON.stringify({
		        service: "room.update_options",
		        body: ["dubstep-den",{"boothLocked":false,"waitListEnabled":true,"maxPlays":1,"maxDJs":5}]
		    }),
		    async: this.async,
		    dataType: 'json',
		    contentType: 'application/json'
		}).done(->
			if callback?
				callback()
			)


data = new settings()