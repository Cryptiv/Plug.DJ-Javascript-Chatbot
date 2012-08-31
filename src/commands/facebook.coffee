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
		
