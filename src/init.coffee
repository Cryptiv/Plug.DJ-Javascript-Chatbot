pupOnline = ->
	API.sendChat "WERF"

populateUserData = ->
	users = API.getUsers()
	data.djs = API.getDJs()
	data.mods = API.getModerators()
	data.host = API.getHost()
	console.log 'Users:',users
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