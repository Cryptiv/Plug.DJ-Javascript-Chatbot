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