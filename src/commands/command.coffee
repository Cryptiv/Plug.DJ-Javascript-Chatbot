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