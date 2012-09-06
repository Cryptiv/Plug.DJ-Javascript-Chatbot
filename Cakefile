fs     = require 'fs'
{exec} = require 'child_process'

appFiles  = [
	# omit src/ and .coffee to make the below lines a little shorter
	'settings'
	'user'
	'room_helper'
	'init'
	'afk'
	'commands/command'
	'commands/protect'
	'commands/cmdhelp'
	'commands/hug'
	'commands/taco'
	'commands/cookie'
	'commands/punish'
	'commands/new_songs'
	'commands/why_woot'
	'commands/theme'
	'commands/rules'
	'commands/room_help'
	'commands/source'
	'commands/woot'
	'commands/bad_quality'
	'commands/download'
	'commands/afks'
	'commands/all_afks'
	'commands/status'
	'commands/unhook'
	'commands/die'
	'commands/reload'
	'commands/lock'
	'commands/unlock'
	'commands/swap'
	'commands/pop'
	'commands/push'
	'commands/reset_afk'
	'commands/force_skip'
	'commands/facebook'
	'commands/overplayed'
	'commands/uservoice'
	'commands/skip'
	'commands/whymeh'
	'commands/commands'
	'commands/disconnect_lookup'
	'commands/vote_ratio'
	'commands/average_vote_ratio'
	'chat_commands'
	'chat'
	'hook_callbacks'
	'hooks'
	'main'
]

task 'build', 'Build single application file from source files', ->
	appContents = new Array remaining = appFiles.length
	for file, index in appFiles then do (file, index) ->
		fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
			throw err if err
			appContents[index] = fileContents

			# Copy the files over to lib, then compile them
			fs.writeFile "lib/#{file}.coffee", fileContents, 'utf8', (err) ->
				throw err if err
				exec "coffee --compile --bare lib/#{file}.coffee", (err, stdout, stderr) ->
					throw err if err
					fs.unlink "lib/#{file}.coffee", (err) ->
						throw err if err
			process() if --remaining is 0
	process = ->
		fs.writeFile 'bin/bot.coffee', appContents.join('\n\n'), 'utf8', (err) ->
			throw err if err
			exec 'coffee --compile bin/bot.coffee', (err, stdout, stderr) ->
				throw err if err
				console.log stdout + stderr
				console.log 'Done'