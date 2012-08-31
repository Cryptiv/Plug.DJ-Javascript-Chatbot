class RoomHelper
	lookupUser: (username)->
		for u in data.users
			if u.getUser().username == u
				return u.getUser()
		return false