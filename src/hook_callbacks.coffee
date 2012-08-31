
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
    #data.users[user.id] = new User(user)
    data.userJoin(user)
    data.users[user.id].updateActivity()
    console.log user.username + " joined the room"
    API.sendChat "/em: " + user.username + " has joined the Den."

handleNewSong = (obj) ->
    data.intervalMessages()
    if(data.currentsong == null)
        data.newSong()#first song since launch
    else
        API.sendChat "/em: Just played " + data.currentsong.title + " by " + data.currentsong.author + ". Stats: Woots: " + data.currentwoots + ", Mehs: " + data.currentmehs + ", Loves: " + data.currentcurates + "."
        data.newSong()
        document.getElementById("button-vote-positive").click()
        API.sendChat "YO SKRILL DROP IT HARD!"  if (data.currentsong.author.indexOf("Skrillex") isnt -1) or (data.currentsong.title.indexOf("Skrillex") isnt -1)
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
    #vote = (if obj.vote is 1 then "woot" else "meh")
    #console.log obj.user.username + " voted " + vote

handleUserLeave = (user)->
    data.host = API.getHost()
    data.mods = API.getModerators()
    console.log user.username + " left the room"
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
    console.log 'User disconnect logged', data.userDisconnectLog
    data.users[user.id].inRoom(false)
    #delete data.users[user.id]

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
                #API.moderateKickUser chat.fromID, "Please don't spam links in this room."
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