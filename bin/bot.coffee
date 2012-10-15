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
	roomUrlPath: null#for lock. 'dubstep-den' in 'http://plug.dj/dubstep-den/'
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
	pupScriptUrl: ''
	afkTime: 12*60*1000#Time without activity to be considered afk. 12 minutes in milliseconds
	songIntervalMessages: [
		{interval:15,offset:0,msg:"I'm a bot!"}
	]
	songCount: 0

	startup: =>
		@launchTime = new Date()
		@roomUrlPath = @getRoomUrlPath()

	getRoomUrlPath: =>
		window.location.pathname.replace(/\//g,'')

	newSong: ->
		@totalVotingData.woots += @currentwoots
		@totalVotingData.mehs += @currentmehs
		@totalVotingData.curates += @currentcurates

		@setInternalWaitlist()

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
				msg['msg']

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
		        body: [@roomUrlPath,{"boothLocked":true,"waitListEnabled":true,"maxPlays":1,"maxDJs":5}]
		    }),
		    async: this.async,
		    dataType: 'json',
		    contentType: 'application/json'
		}).done ->
			if callback?
				callback()

	unlockBooth: (callback=null)->
		$.ajax({
		    url: "http://www.plug.dj/gateway/room.update_options",
		    type: 'POST',
		    data: JSON.stringify({
		        service: "room.update_options",
		        body: [@roomUrlPath,{"boothLocked":false,"waitListEnabled":true,"maxPlays":1,"maxDJs":5}]
		    }),
		    async: this.async,
		    dataType: 'json',
		    contentType: 'application/json'
		}).done ->
			if callback?
				callback()


data = new settings()

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

class RoomHelper
	lookupUser: (username)->
		for id,u of data.users
			if u.getUser().username == username
				return u.getUser()
		return false

	userVoteRatio: (user)->
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

pupOnline = ->
	API.sendChat "Bot Online!"

populateUserData = ->
	users = API.getUsers()
	data.djs = API.getDJs()
	data.mods = API.getModerators()
	data.host = API.getHost()
	for u in users
		data.users[u.id] = new User(u)
		data.voteLog[u.id] = {}
	return

initEnvironment = ->
	document.getElementById("button-vote-positive").click()
	document.getElementById("button-sound").click()
	Playback.streamDisabled = true
	Playback.stop()

initialize = ->
  pupOnline()
  populateUserData()
  initEnvironment()
  initHooks()
  data.startup()
  data.newSong()
  data.startAfkInterval()

afkCheck = ->
  for id,user of data.users
    now = new Date()
    lastActivity = user.getLastActivity()
    timeSinceLastActivity = now.getTime() - lastActivity.getTime()
    if timeSinceLastActivity > data.afkTime #has been inactive longer than afk time limit
      if user.getIsDj()#if on stage
        secsLastActive = timeSinceLastActivity / 1000
        if user.getWarningCount() == 0
          user.warn()
          "@"+user.getUser().username+", I haven't seen you chat or vote in at least 12 minutes. Are you AFK?  If you don't show activity in 2 minutes I will remove you."
        else if user.getWarningCount() == 1
          lastWarned = user.getLastWarning()#last time user was warned
          timeSinceLastWarning = now.getTime() - lastWarned.getTime()
          twoMinutes = 2*60*1000
          if timeSinceLastWarning > twoMinutes
            user.warn()
            warnMsg = "@"+user.getUser().username
            warnMsg += ", I haven't seen you chat or vote in at least 14 minutes now.  This is your second and FINAL warning.  If you do not chat or vote in the next minute I will remove you."
            warnMsg
        else if user.getWarningCount() == 2#Time to remove
          lastWarned = user.getLastWarning()#last time user was warned
          timeSinceLastWarning = now.getTime() - lastWarned.getTime()
          oneMinute = 1*60*1000
          if timeSinceLastWarning > oneMinute
            DJs = API.getDJs()
            if DJs.length > 0 and DJs[0].id != user.getUser().id
              "@"+user.getUser().username+", you had 2 warnings. Please stay active by chatting or voting."
              user.warn()
      else
        user.notDj()

msToStr = (msTime) ->
  msg = ''
  timeAway = {'days':0,'hours':0,'minutes':0,'seconds':0}
  ms = {'day':24*60*60*1000,'hour':60*60*1000,'minute':60*1000,'second':1000}

  #split into days hours minutes and seconds
  if msTime > ms['day']
    timeAway['days'] = Math.floor msTime / ms['day']
    msTime = msTime % ms['day']
  if msTime > ms['hour']
    timeAway['hours'] = Math.floor msTime / ms['hour']
    msTime = msTime % ms['hour']
  if msTime > ms['minute']
    timeAway['minutes'] = Math.floor msTime / ms['minute']
    msTime = msTime % ms['minute']
  if msTime > ms['second']
    timeAway['seconds'] = Math.floor msTime / ms['second']

  #add non zero times
  if timeAway['days'] != 0
    msg += timeAway['days'].toString() + 'd'
  if timeAway['hours'] != 0
    msg += timeAway['hours'].toString() + 'h'
  if timeAway['minutes'] != 0
    msg += timeAway['minutes'].toString() + 'm'
  if timeAway['seconds'] != 0
    msg += timeAway['seconds'].toString() + 's'

  if msg != ''
    return msg
  else
    return false

class Command
	
	# Abstract of chat command
	# 	Required Attributes:
	# 		@parseType: How the chat message should be evaluated
	# 			- Options:
	# 				- 'exact' = chat message should exactly match command string
	# 				- 'startsWith' = substring from start of chat message to length
	# 					of command string should equal command string
	# 				- 'contains' = chat message contains command string
	# 		@command: String or Array of Strings that, when matched in message
	# 			corresponding with commandType, triggers bot functionality
	# 		@rankPrivelege: What user types are allowed to use this function
	# 			- Options:
	# 				- 'host' = only can be called by host
	# 				- 'mod' = can be called by host and mods
	# 				- 'user' = can be called by hosts, mods, and all users
	# 				- {'pointMin':min} = can be called by hosts and mods.  Users
	# 					can call if the # of points they have > pointMin
	# 		@functionality: actions bot will perform if conditions are satisfied
	# 			for chat command

	constructor: (@msgData) ->
		@init()

	init: ->
		@parseType=null
		@command=null
		@rankPrivelege=null

	functionality: (data)->
		return

	hasPrivelege: ->
		user = data.users[@msgData.fromID].getUser()
		if(@rankPrivelege=='host')
			if(user.owner)
				return true
			else
				return false
		else if(@rankPrivelege=='mod')
			if(user.owner || user.moderator)
				return true
			else
				return false
		else if(@rankPrivelege=='user')
			return true

	commandMatch: ->
		msg = @msgData.message
		if(typeof @command == 'string')
			if(@parseType == 'exact')
				if(msg == @command)
					return true
				else
					return false
			else if(@parseType == 'startsWith')
				if(msg.substr(0,@command.length) == @command)
					return true
				else
					return false
			else if(@parseType == 'contains')
				if(msg.indexOf(@command) != -1)
					return true
				else
					return false
		else if(typeof @command == 'object')
			for command in @command
				if(@parseType == 'exact')
					if(msg == command)
						return true
				else if(@parseType == 'startsWith')
					if(msg.substr(0,command.length) == command)
						return true
				else if(@parseType == 'contains')
					if(msg.indexOf(command) != -1)
						return true
			return false
			
	evalMsg: ->
		if(@commandMatch() && @hasPrivelege())
			@functionality()
			return true
		else
			return false

class protectCommand extends Command
	init: ->
		@command='/protect'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		msg = @msgData.message
		if msg.length > 9 #includes arg
			username = msg.substring(10)
			for id,user of data.users
				if user.getUser().username == username
					user.protected = true
					API.sendChat "I shall protect you @"+username+" (I just wont kick you)"
					return
		API.sendChat "That aint no name I ever did see"
		return
		


class cmdHelpCommand extends Command
	init: ->
		@command='/cmdhelp'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = @msgData.message
		resp = ''
		if msg.length > 9 #includes param
			param = msg.substring 9 #just param
			switch param
				when "hugs pup"
					resp = "You give me a hug!"
				when "rapes pup"
					resp = "er... thats... not a command... please"
				when "taco"
					resp = "order a yummy taco.  simply say 'taco' or give on to someone else by saying 'taco @user'"
				when "cookie"
					resp = "Mod only command.  Reward a user with a sweet treat!  Syntax: cookie @user"
				when "punish"
					resp = "Mod only command.  Punish a user in one of several methods.  For naughty users.  Syntax: punish @user"
				when "/newsongs"
					resp = "find new songs by checking out one of 40+ dubstep channels that post new music daily"
				when "/whywoot"
					resp = "DJ all day without throwing your life away clicking woot every 3 minutes.  Learn how and get the necessary tools"
				when "/theme"
					resp = "Learn what genres of music are generally accepted here.  Don't forget to check if your song is in /overplayed though"
				when "/rules"
					resp = "Room rules.  Duh"
				when "/roomhelp"
					resp = "Information about the room for the newer folk."
				when "/source"
					resp = "About the bot and the code that produced it"
				when "/sourcecode"
					resp = "About the bot and the code that produced it"
				when "/author"
					resp = "About the bot and the code that produced it"
				when "/woot"
					resp = "Remind users to hit woot so they don't get removed.  either type /woot or /woot @user"
				when ".128"
					resp = "Mod only command. Flags songs that are bad quality."
				when "/tableflip"
					resp = "... flips a table"
				when "/tablefix"
					resp = "... fixes a table"
				when "/download"
					resp = "Provides a link to find downloads of mp3 of current song"
				when "/smokesesh"
					resp = "For when ya just wanna get high"
				when "/smoke"
					resp = "doobies"
				when "/dab"
					resp = "WOLVES uses this"
				when "/afks"
					resp = "List current DJs on deck that haven't chatted or voted in 5+ minutes"
				when "/allafks"
					resp = "List all users in room that haven't chatted or voted in 10+ minutes"
				when "/status"
					resp = "Uptime and total song stats"
				when "/unhook events all"
					resp = "Host only command.  It's complicated"
				when "/die"
					resp = "Host only command. Makes bot go bye bye"
				when "/reload"
					resp = "Host only command. Reload pup's script"
				when "/lock"
					resp = "Mod only command. Locks booth"
				when "/unlock"
					resp = "Mod only command. Unlocks booth"
				when "/overplayed"
					resp = "Links users to our overplayed song list"
				when "/whymeh"
					resp = "Explains to users why they should be mehing every song"
				when "/skip"
					resp = "Mod only command.  Skips song.  Works for skipping invisible DJs."
				when "/commands"
					resp = "Lists all commands.  Will only list commands available to caller's user class (user, mod, or host)"
				when "/resetafk"
					resp = "Mod only command.  Resets AFK timer for user.  Syntax: /resetafk @USER"
				when "/forceskip"
					resp = "Host only command.  Make pup skip songs when they are supposed to end (addresses triangles of death issue). Syntax: /forceskip [enable|disable]"
				when "/fb"
					resp = "Links to Dubstep Den's facebook page"
				when "/uservoice"
					resp = "Links to Dubstep Den's uservoice page"
				when "/dclookup"
					resp = "Mod only command.  Looks up user for a log of their last disconnect. Syntax: /dclookup @USER"
				when "/reminder"
					resp = "Mod only command.  Set reminder for x songs from now.  For users that dc'd mainly.  Syntax: /reminder \"MSG\" [numsongs]"
				when "/voteratio"
					resp = "Mod only command.  See woot & meh count for user since bot launch.  Syntax: /voteratio @USER"
				when "/avgvoteratio"
					resp = "Mod only command.  See average voting ratio of every present user in room. Syntax: /avgvoteratio"
				when "/cmdhelp"
					resp = "Looks like you got it down"
				when "/pop"
					resp = "Mod only command.  Removes last person on deck"
				when "/push"
					resp = "Mod only command.  Puts user on deck. Syntax: /push @user"
				else
					resp = "That is nothing.  That is not a thing."
		else # none
			resp = "Use this command to learn how use other commands.  Syntax: /cmdhelp [/CMD]"

		API.sendChat resp
		


class hugCommand extends Command
	init: ->
		@command='hugs bot'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat "hugs @" + @msgData['from']


class tacoCommand extends Command
	init: ->
		@command='pizza'
		@parseType='startsWith'
		@rankPrivelege='user'

	randomTaco: ->
		tacos = [
				"cheese pizza",
				"pepperoni pizza",
				"hawaiian pizza",
				"BBQ chicken pizza",
				"anchovies pizza",
				"DNCH turkey pizza",
				"Adam's pepperoni pizza",
				"vegan pizza"
			];
		t = Math.floor Math.random()*tacos.length
		return tacos[t]

	functionality: ->
		msg = @msgData.message
		r = new RoomHelper()
		if msg.length > 8 #includes username
			user = r.lookupUser(msg.substr(8))
			if user == false
				API.sendChat "/em doesn't see '"+msg.substr(8)+"' in room and eats pizza himself"
				return false
			else
				API.sendChat "@"+user.username+", @"+@msgData.from+" has rewarded you with some "+@randomTaco()+"."

class cookieCommand extends Command
	init: ->
		@command='cookie'
		@parseType='startsWith'
		@rankPrivelege='mod'

	getCookie: ->
		cookies = [
			"a chocolate chip cookie"
			"a sugar cookie"
			"an oatmeal raisin cookie"
			"a 'special' brownie"
			"an animal cracker"
			"a scooby snack"
			"a blueberry muffin"
			"a cupcake"
		]
		c = Math.floor Math.random()*cookies.length
		cookies[c]

	functionality: ->
		msg = @msgData.message
		r = new RoomHelper()
		if msg.length > 8 #includes username
			user = r.lookupUser(msg.substr(8))
			if user == false
				API.sendChat "/em doesn't see '"+msg.substr(8)+"' in room and eats cookie himself"
				return false
			else
				API.sendChat "@"+user.username+", @"+@msgData.from+" has rewarded you with "+@getCookie()+". Enjoy."

class punishCommand extends Command
	init: ->
		@command='punish'
		@parseType='startsWith'
		@rankPrivelege='mod'

	getPunishment: (username)->
		punishments=[
			"/me rubs sandpaper on @{victim}'s scrotum"
			"/me pokes @{victim} in the eyes"
			"/me throws sand in @{victim}'s eyes"
			"/me makes @{victim}'s mother cry"
			"/me penetrates @{victim} with a sharpie"
			"/me pinches @{victim}'s nipples super hard"
			"/me gives @{victim} a wet willy"
			"/me pulls @{victim}'s hair out"
			"/me gives @{victim} a paper cut"
			"/me  ties @{victim} at the ankles with skipping rope and hangs him upside down over an audience of wild boars in heat."
		]
		p = Math.floor Math.random()*punishments.length
		punishment = punishments[p].replace('{victim}',username)
		punishment

	functionality: ->
		msg = @msgData.message
		r = new RoomHelper()
		if msg.length > 8 #username
			name = msg.substr(8)
			user = r.lookupUser name
			if user == false
				API.sendChat "/me punishes @"+@msgData.from+" for getting the syntax wrong."
				setTimeout(->
					API.sendChat "Seriously though, I don't recognize the username '"+name+"'",
				750)
			else
				if user.owner
					API.sendChat @getPunishment @msgData.from
				else
					API.sendChat @getPunishment(user.username)

class newSongsCommand extends Command
	init: ->
		@command='/newsongs'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		mChans = @memberChannels.slice(0)
		chans = @channels.slice(0)#shallow copies
		arts = @artists.slice(0)
		#list local so lists don't shrink as function is called over time
		chooseRandom= (list)->
			l = list.length
			r = Math.floor Math.random()*l
			return list.splice(r,1)

		selections =
			channels : [],
			artist : ''
		u = data.users[@msgData.fromID].getUser().username
		if(u.indexOf("MistaDubstep") != -1)
			selections['channels'].push 'MistaDubstep'
		else if(u.indexOf("Underground Promotions") != -1)
			selections['channels'].push 'UndergroundDubstep'
		else
			selections['channels'].push chooseRandom mChans	
		selections['channels'].push chooseRandom chans
		selections['channels'].push chooseRandom chans

		cMedia = API.getMedia()
		if cMedia.author in arts
			selections['artist'] = cMedia.author
		else
			selections['artist'] = chooseRandom arts

		msg = "Everyone's heard that " + selections['artist'] +
		" track! Get new music from " + selections['channels'][0] + " , "
		+ selections['channels'][1] + " or " + selections['channels'][2];

		API.sendChat(msg)

	# memChanLen = memberChannels.length
 #      chanLen = channels.length
 #      artistsLen = artists.length
 #      mc1 = Math.floor(Math.random() * memChanLen)
 #      mchan1 = memberChannels.splice(mc1, 1)
 #      mc2 = Math.floor(Math.random() * memChanLen - 1)
 #      mchan2 = memberChannels.splice(mc2, 1)
 #      c1 = Math.floor(Math.random() * (chanLen))
 #      chan = channels.splice(c1, 1)
 #      a1 = Math.floor(Math.random() * artistsLen)
 #      API.sendChat "Everyone's heard that " + artists[a1] + " track! Get new music from http://youtube.com/" + mchan1 + " http://youtube.com/" + mchan2 + " or http://youtube.com/" + chan
		
	memberChannels: [
		"http://www.youtube.com/indieplus4"
	]
	channels: [
		"http://thekollection.com/category/indie/",
		"http://wearehunted.com/a/#/emerging/",
		"http://www.facebook.com/FringeMusicFix",
		"http://www.youtube.com/musicianswanted"
	]
	artists: [
		"Taylor Swift",
		"Justin Beiber",
		"One Direction",
		"Kanye West"
	]


class whyWootCommand extends Command
	init: ->
		@command='/whywoot'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "It's nice and you get points."

		if((nameIndex = @msgData.message.indexOf('@')) != -1)
			API.sendChat @msgData.message.substr(nameIndex) + ', ' + msg
		else
			API.sendChat msg

class themeCommand extends Command
	init: ->
		@command='/theme'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "We play primarily Indie Rock, Pop, Folk and Electronic but ALL GENRES ARE ALWAYS WELCOME. "
		msg += "Subject to votes of disapproval of course."
		API.sendChat(msg)


class rulesCommand extends Command
	init: ->
		@command='/rules'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "1) Be kind. No trolling. "
		msg += "2) Be open minded. Avoid racism and homophobia. "
		msg += "3) Be respectful towards everyone including mods. "
		msg += "4) Let your votes do the talking."
		API.sendChat(msg)
		


class roomHelpCommand extends Command
	init: ->
		@command='/roomhelp'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg1 = "Welcome to INDIE+! Create a playlist and populate it with songs from either YouTube, Soundcloud, or iTunes.  "
		msg1+= "Click the 'Join Waitlist/Click to DJ' button and wait your turn to play music. Type '/theme' for specific genres."

		msg2 = "Play good quality music that hasn't been played recently (check room history).  "
		msg2+= "Avoid over played artists. Ask a mod if you're unsure about your song choice"
		API.sendChat(msg1)
		setTimeout (-> API.sendChat msg2), 750
		


class sourceCommand extends Command
	init: ->
		@command=['/source', '/sourcecode', '/author']
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = 'Originally Backus wrote me in CoffeeScript. I was edited/updated by INDIE+'
		API.sendChat msg

class wootCommand extends Command
	init: ->
		@command='/woot'
		@parseType='startsWith'
		@rankPrivelege='user'

	functionality: ->
		msg = "DANCE!"
		if((nameIndex = @msgData.message.indexOf('@')) != -1)
			API.sendChat @msgData.message.substr(nameIndex) + ', ' + msg
		else
			API.sendChat msg

class badQualityCommand extends Command
	init: ->
		@command='.128'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		msg = "Flagged for bad sound quality. Where do you get your music? The garbage can? Don't play this low quality tune again!"
		API.sendChat msg

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

class unhookCommand extends Command
	init: ->
		@command='/unhook events all'
		@parseType='exact'
		@rankPrivelege='host'

	functionality: ->
		API.sendChat 'Unhooking all events...'
		undoHooks()
		


class dieCommand extends Command
	init: ->
		@command='/die'
		@parseType='exact'
		@rankPrivelege='host'

	functionality: ->
		API.sendChat 'Unhooking Events...'
		undoHooks()
		API.sendChat 'Deleting bot data...'
		data.implode()
		API.sendChat 'Consider me dead'


class reloadCommand extends Command
	init: ->
		@command='/reload'
		@parseType='exact'
		@rankPrivelege='host'

	functionality: ->
		API.sendChat 'brb'
		undoHooks()
		pupSrc = data.pupScriptUrl
		data.implode()
		$.getScript(pupSrc)

class lockCommand extends Command
	init: ->
		@command='/lock'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		'Pop and lock dat ish'
		data.lockBooth()


class unlockCommand extends Command
	init: ->
		@command='/unlock'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		'You\'ll never get the key to unlock my heart'
		data.unlockBooth()


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

class popCommand extends Command
	init: ->
		@command='/pop'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		djs = API.getDJs()
		popDj = djs[djs.length-1]
		API.moderateRemoveDJ(popDj.id)

class pushCommand extends Command
	init: ->
		@command='/push'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		msg = @msgData.message
		if msg.length>@command.length+2#'/push @'
			name = msg.substr(@command.length+2)
			r = new RoomHelper()
			user = r.lookupUser(name)
			if user != false
				API.moderateAddDJ user.id

class resetAfkCommand extends Command
	init: ->
		@command='/resetafk'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		if @msgData.message.length > 10
			name = @msgData.message.substring(11)#remove @
			for id,u of data.users
				if u.getUser().username == name
					u.updateActivity()
					API.sendChat '@' + u.getUser().username + '\'s AFK time has been reset.'
					return
			API.sendChat 'Not sure who ' + name + ' is'
			return
		else
			API.sendChat 'Yo Gimme a name r-tard'
			return

class forceSkipCommand extends Command
	init: ->
		@command='/forceskip'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		msg = @msgData.message
		if msg.length > 11 #command switch included
			param = msg.substr(11)
			if param == 'enable'
				data.forceSkip = true
				API.sendChat "Forced skipping enabled."
			else if param == 'disable'
				data.forceSkip = false
				API.sendChat "Forced skipping disabled."
		

class fbCommand extends Command
	init: ->
		@command='/fb'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		m = Math.floor Math.random()*@msgs.length
		msg = @msgs[m].replace('{fb}','http://on.fb.me/HNzK5S')
		API.sendChat msg

	msgs: [
		"Don't have any friends in real life? That's ok, we'll be your friend.  Join our facebook group: {fb}",
		"Wondering what TIMarbury looks like?  Join our facebook group ({fb}) and find out for yourself!",
		"We have a facebook group. Join it. Please. {fb}",
		"The Dubstep Den is now on friendster! lol just kidding.  Here's our facebook group: {fb} you should join.",
		"I bet you're handsome.  Join our facebook group so me0w can stalk your photos: {fb}"
	]
		


class overplayedCommand extends Command
	init: ->
		@command=''
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		API.sendChat "View the list of songs we consider overplayed and suggest additions at http://den.johnback.us/overplayed_tracks"
		


class uservoiceCommand extends Command
	init: ->
		@command=''
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = 'Have an idea for the room, our bot, or an event?  Awesome! Submit it to our uservoice and we\'ll get started on it: http://is.gd/IzP4bA'
		msg += ' (please don\'t ask for mod)'
		API.sendChat(msg)


class skipCommand extends Command
	init: ->
		@command='/skip'
		@parseType='exact'
		@rankPrivelege='mod'

	functionality: ->
		API.moderateForceSkip()
		


class whyMehCommand extends Command
	init: ->
		@command=''
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		msg = "Reserve Mehs for songs that are a) extremely overplayed b) off genre c) absolutely god awful or d) troll songs. "
		msg += "If you simply aren't feeling a song, then remain neutral"
		API.sendChat msg

class commandsCommand extends Command
	init: ->
		@command='/commands'
		@parseType='exact'
		@rankPrivelege='user'

	functionality: ->
		allowedUserLevels = []
		user = API.getUser(@msgData.fromID)
		if user.owner
			allowedUserLevels = ['user','mod','host']
		else if user.moderator
			allowedUserLevels = ['user','mod']
		else
			allowedUserLevels = ['user']
		msg = ''
		for cmd in cmds
			c = new cmd('')
			if c.rankPrivelege in allowedUserLevels
				if typeof c.command == "string"
					msg += c.command + ', '
				else if typeof c.command == "object"
					for cc in c.command
						msg += cc + ', '
		msg = msg.substring(0,msg.length-2)
		API.sendChat msg
		


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

class voteRatioCommand extends Command
	init: ->
		@command='/voteratio'
		@parseType='startsWith'
		@rankPrivelege='mod'

	functionality: ->
		r = new RoomHelper()
		msg = @msgData.message
		if msg.length > 12 #includes username
			name = msg.substr(12)
			u = r.lookupUser(name)
			if u != false
				votes = r.userVoteRatio(u)
				msg = u.username + " has wooted "+votes['woot'].toString()+" time"
				if votes['woot'] == 1
					msg+=', '
				else
					msg+='s, '
				msg += "and meh'd "+votes['meh'].toString()+" time"
				if votes['meh'] == 1
					msg+='. '
				else
					msg+='s. '
				msg+="Their woot:vote ratio is " + votes['positiveRatio'].toString() + "."
				API.sendChat msg
			else
				API.sendChat "I don't recognize a user named '"+name+"'"
		else
			API.sendChat "I'm not sure what you want from me..."
		


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
		
		

cmds = [
	hugCommand,
	tacoCommand,
	cookieCommand,
	punishCommand,
	newSongsCommand,
	whyWootCommand,
	themeCommand,
	rulesCommand,
	roomHelpCommand,
	sourceCommand,
	wootCommand,
	badQualityCommand,
	downloadCommand,
	afksCommand,
	allAfksCommand,
	statusCommand,
	unhookCommand,
	dieCommand,
	reloadCommand,
	lockCommand,
	unlockCommand,
	swapCommand,
	popCommand,
	pushCommand,
	overplayedCommand,
	uservoiceCommand,
	whyMehCommand,
	skipCommand,
	commandsCommand,
	resetAfkCommand,
	forceSkipCommand,
	fbCommand,
	cmdHelpCommand,
	protectCommand,
	disconnectLookupCommand,
	voteRatioCommand,
	avgVoteRatioCommand
]

chatCommandDispatcher = (chat)->
    chatUniversals(chat)
    for cmd in cmds
    	c = new cmd(chat)
    	if c.evalMsg()
    		break

﻿
updateVotes = (obj) ->
    data.currentwoots = obj.positive
    data.currentmehs = obj.negative
    data.currentcurates = obj.curates

announceCurate = (obj) ->
    API.sendChat "/em: " + obj.user.username + " loves this song!"

updateDjs = (obj) ->
    data.djs = API.getDJs()

handleUserJoin = (user) ->
    data.host = API.getHost()
    data.mods = API.getModerators()
    data.userJoin(user)
    data.users[user.id].updateActivity()
    API.sendChat "/em: " + user.username + " has joined the Room!"

handleNewSong = (obj) ->
    data.intervalMessages()
    if(data.currentsong == null)
        data.newSong()#first song since launch
    else
        "/em: Just played " + data.currentsong.title + " by " + data.currentsong.author + ". Stats: Woots: " + data.currentwoots + ", Mehs: " + data.currentmehs + ", Loves: " + data.currentcurates + "."
        data.newSong()
        document.getElementById("button-vote-positive").click()
    if data.forceSkip # skip songs when song is over
        songId = obj.media.id
        setTimeout ->
            cMedia = API.getMedia()
            if cMedia.id == songId
                API.moderateForceSkip()
        ,(obj.media.duration * 1000)

handleVote = (obj) ->
    data.users[obj.user.id].updateActivity()
    data.users[obj.user.id].updateVote(obj.vote)

handleUserLeave = (user)->
    data.host = API.getHost()
    data.mods = API.getModerators()
    disconnectStats = {
        id : user.id
        time : new Date()
        songCount : data.songCount
    }
    i=0
    for u in data.internalWaitlist
        if u.id == user.id
            disconnectStats['waitlistPosition'] = i-1#0th position -> 1 song away
            data.setInternalWaitlist()#reload waitlist now that someone left
            break
        else
            i++
    data.userDisconnectLog.push(disconnectStats)
    data.users[user.id].inRoom(false)

antispam = (chat)->
    #test if message contains plug.dj room link
    plugRoomLinkPatt = /(\bhttps?:\/\/(www.)?plug\.dj[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    if(plugRoomLinkPatt.exec(chat.message))
        #plug spam detected
        sender = API.getUser chat.fromID
        if(!sender.ambassador and !sender.moderator and !sender.owner and !sender.superuser)
            if !data.users[chat.fromID].protected
                API.sendChat "Don't spam room links you ass clown"
                API.moderateDeleteChat chat.chatID
            else
                API.sendChat "I'm supposed to kick you, but you're just too darn pretty."

beggar = (chat)->
    msg = chat.message.toLowerCase()
    responses = [
        "Good idea @{beggar}!  Don't earn your fans or anything thats so yesterday"
        "Guys @{beggar} asked us to fan him!  Lets all totally do it! ಠ_ಠ"
        "srsly @{beggar}? ಠ_ಠ"
        "@{beggar}.  Earning his fans the good old fashioned way.  Hard work and elbow grease.  A true american."
    ]
    r = Math.floor Math.random()*responses.length
    if msg.indexOf('fan me') != -1 or msg.indexOf('fan for fan') != -1 or msg.indexOf('fan pls') != -1 or msg.indexOf('fan4fan') != -1 or msg.indexOf('add me to fan') != -1
        API.sendChat responses[r].replace("{beggar}",chat.from)

chatUniversals = (chat)->
    data.activity(chat)
    antispam(chat)
    beggar(chat)

hook = (apiEvent,callback) ->
    API.addEventListener(apiEvent,callback)

unhook = (apiEvent,callback) ->
    API.removeEventListener(apiEvent,callback)

apiHooks = [
    {'event':API.ROOM_SCORE_UPDATE, 'callback':updateVotes},
    {'event':API.CURATE_UPDATE, 'callback':announceCurate},
    {'event':API.DJ_UPDATE, 'callback':updateDjs},
    {'event':API.USER_JOIN, 'callback':handleUserJoin},
    {'event':API.DJ_ADVANCE, 'callback':handleNewSong},
    {'event':API.VOTE_UPDATE, 'callback':handleVote},
    {'event':API.CHAT, 'callback':chatCommandDispatcher},
    {'event':API.USER_LEAVE, 'callback':handleUserLeave}
]

initHooks = ->
	hook pair['event'], pair['callback'] for pair in apiHooks

undoHooks = ->
    unhook pair['event'], pair['callback'] for pair in apiHooks

initialize()