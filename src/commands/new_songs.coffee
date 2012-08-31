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
		" track! Get new music from http://youtube.com/" + selections['channels'][0] +
		" http://youtube.com/" + selections['channels'][1] + 
		" or http://youtube.com/" + selections['channels'][2];

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
		"JitterStep",
		"MistaDubstep",
		"DubStationPromotions",
		"UndergroundDubstep",
		"JesusDied4Dubstep",
		"DarkstepWarrior",
		"BombshockDubstep",
		"Sharestep"
	]
	channels: [
		"BassRape",
		"Mudstep",
		"WobbleCraftDubz",
		"MonstercatMedia",
		"UKFdubstep",
		"DropThatBassline",
		"Dubstep",
		"VitalDubstep",
		"AirwaveDubstepTV",
		"EpicNetworkMusic",
		"NoOffenseDubstep",
		"InspectorDubplate",
		"ReptileDubstep",
		"MrMoMDubstep",
		"FrixionNetwork",
		"IcyDubstep",
		"DubstepWeed",
		"VhileMusic",
		"LessThan3Dubstep",
		"PleaseMindTheDUBstep",
		"ClownDubstep",
		"TheULTRADUBSTEP",
		"DuBM0nkeyz",
		"DubNationUK",
		"TehDubstepChannel",
		"BassDropMedia",
		"USdubstep",
		"UNITEDubstep" 
	]
	artists: [
		"Skrillex",
		"Doctor P",
		"Excision",
		"Flux Pavilion",
		"Knife Party",
		"Krewella",
		"Rusko",
		"Bassnectar",
		"Nero",
		"Deadmau5"
		"Borgore"
		"Zomboy"
	]
