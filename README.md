Plug.DJ Moderation Helper Bot
==========================
Written by John Backus - http://johnback.us/

##Table of Contents

1. [Overview](#overview)
2. [Bot Features](#bot-features)
3. [Bot Commands Overview](#bot-commands-overview)
  1. [Included Commands](#included-commands)
  2. [Writing New Commands](#writing-new-commands)
4. [How to compile and run](#how-to-compile-and-run)


##Overview
This bot is written to help:

1. Automate certain aspects of room moderation
2. Provide moderators additional tools to make their job easier
3. Track certain room statistics to optimize DJing experience (AFK status, vote ratios, disconnect logs)
4. Be fun to use

##Bot Features
###Moderation Automation
#####AFK Monitor
* Presumably, you want users that are active and at their computer to DJ, not people AFK (Away From Keyboard) users.  The bot monitors every user in the room and tracks when they last voted and chatted.
  * Process:
    * By default, the bot will ping & warn a user that joins the DJ booth if they haven't displayed activity within the last 12 minutes.
    * It will provide them a second warning if they still haven't chatted two minutes after that.
    * Finally, if they don't show activity after one more minute, they are removed from the booth.
  * Note: this feature can (and should) be modified depending on the room the bot is being used for:
    * Small rooms can disable the feature
    * Medium sized rooms can make the AFK time window longer and therefore more forgiving
    * Large rooms (or rooms with a lot of users that automate wooting) can make the system chat only
  * Example

\#Wolf Pup warning and removing Jerm:

    [2:45pm] #Wolf Pup: @Jerm, I haven't seen you chat or vote in at least 12 minutes. Are you AFK?  If you don't show activity in 2 minutes I will remove you.
    [2:47pm] #Wolf Pup: @Jerm, I haven't seen you chat or vote in at least 14 minutes now.  This is your second and FINAL warning.  If you do not chat or vote in the next minute I will remove you."
    [2:49pm] #Wolf Pup: @Jerm, you had 2 warnings. Please stay active by chatting or voting.
    [2:49pm] #Wolf Pup removed Jerm from the DJ booth.
    
#####Forceskip Song Override
* Problem: Plug.DJ's _Triangles of Death_ bug
  * When this bug occurs, instead of moving on to the next song when a DJ's track ends, the triangle animation plays indefinitely until a moderator or the DJ skips.
    * If this bug occurs, and the room doesn't have a bot or moderators dilligently skipping, the room slips into silence and nearly all active users leave.
* Solution
  * With the help of the bot, the room host can type: `/forceskip enable` and the bot will auto-skip every song as soon as it ends.

#####Anti-Spam Handler
* Problem: People spam links in your room
  * When your room reaches to top, other rooms try to steal users by spamming their room link in your room.
* Solution
  1. Plug.DJ introduced a simple anti-spam solution: Messages that include room links sent by users that joined the room <5 minutes earlier are not displayed to other users.
  2. The bot deletes messages sent by non-moderators that include links to other rooms.
* A word of caution
  * The bot *can* be configured to kick users that link plug.dj rooms, but here is why I don't recommend this solution:
    * What happened when [Klaypex](https://www.facebook.com/Klaypex) wanted to promote our room: http://johnback.us/img/Bot_Fail.png

#####Interval based room announcements
* If you have a facebook group link you would like to share, or any message you would like to regularly announce, the bot can be configured to say a certain message every X number of songs.

###Host/Moderator tools
#####Waitlist Disconnect Monitor
* For whatever reason, users sometimes disconnect from Plug.DJ rooms.  This sucks if they have been on a waitlist to play a song for over an hour 
* Solution:
  * The bot monitors the room's waitlist and DJ stand.  If a user disconnects from the room while on the stage or on the waitlist, it logs their disconnect.  Mods can use a command to check disconnects.
  * Mod command usage example:
    
Dimi looking up my disconnect:

    Ɖimi: /dclookup @backus
    #Wolf Pup: backus has disconnected 1 time. Their most recent disconnect was at 10:29 AM (2 songs ago). 
    They were 4 songs away from the DJ booth.

#####Visitor tracking
* Users are welcomed when they join the room.
* Each unique user is stored within the bot in their own user object, and flagged as offline in object if they disconnect. This way, vote statistics and similar data can be stored about a user even after the disconnect and reconnect.

#####Booth controls
* The bot simplifies the process of locking and unlocking the booth, adding and removing users, and swapping users with:
  * `/lock`
  * `/unlock`
  * `/pop`
  * `/push @user`
  * `/swap @user_to_remove for @user_to_add`

#####AFK Override Commands
* For special circumstances, a mod can reset a user's AFK time using `/afkreset @user`
* For VIPs, `/protect @user` ensures they won't be kicked or removed for being AFK
#####New song recommendation
* A list of youtube channels with new music can be configured for recommending to new visitors that play overplayed songs.
* Example:

A user plays overplayed song:

    *Panda Attack started playing 'Scary Monsters and Nice Sprites' by Skrillex*
    backus: /newsongs
    #Wolf Pup: Everyone's heard that Skrillex track! Get new music from http://youtube.com/MistaDubstep http://youtube.com/UndergroundDubstep or http://youtube.com/JitterStep

#####Roomhelp, Theme, Vote Rules, Bad Quality Flag
* Configure commands (and create new commands) for automating frequently explained messages.
* By default, the bot comes with:
  * `/roomhelp` - Inform new users how the room works
  * `/whywoot` - Teach users why voting is important to show that they are active
  * `/whymeh` - Tell users that Meh'ing should be saved for songs they really hate
  * `/theme` - Notify users what genres are allowed
  * `/source` - Share with users who created this bot.

###Statistics
* User Vote Monitor
  * The bot tracks how every user votes for each song.
  * This is useful for users that Meh way more than others.
  * Lookup vote stats example:

Dimi looks up DJ P0N-3's vote stats:

    Ɖimi: /voteratio @DJ P0N-3
    #Wolf Pup: DJ P0N-3 has wooted 88 times, and meh'd 4 times. Their woot:vote ratio is 0.95.

##Bot Commands Overview

###Included Commands

####Host Commands
----------------------
#####__Command__: `/forceskip`
#####_Description_:
Skip every song manually after it ends.
#####_Syntax_:

Command:

    /forceskip [enable|disable]

Parameters:

    enable    Enables bot enforced song skips
    disable   Disables

#####_Example_:

Enable:

    backus: /forceskip enable
    #Wolf Pup: Forced skipping enabled.

Disable:

    backus: /forceskip disable
    #Wolf Pup: Forced skipping disabled.
----------------------
#####__Command__: `/reload`
#####_Description_:
Restarts bot by reloading script and events. Wipes bot data.
#####_Syntax_: 

Command:

    /reload

#####_Example_:

Reloading pup:

    backus: /reload
    #Wolf Pup: brb
    #Wolf Pup: WOOF

----------------------
#####__Command__: `/die`
#####_
#####_Syntax_: 

    /die

#####_Example_:

Using die:

    backus: /die
    #Wolf Pup: Unhooking Events...
    #Wolf Pup: Deleting bot data...
    #Wolf Pup: Consider me dead
----------------------
####Moderator Commands
----------------------
#####__Command__: `cookie`
#####_Description_:
Fun command for rewarding users.
#####_Syntax_: 

Command:

    cookie @user

Parameters:

    @user    Recipient of reward cookie

#####_Example_:

Successful case:

    backus: cookie @WOLVES
    #Wolf Pup: @WOLVES, @backus has rewarded you with a sugar cookie. Enjoy.

Unsuccessful case - Non existant user:

    backus: cookie @NonExistantUser
    #Wolf Pup doesn't see 'NonExistantUser' in room and eats cookie himself

Unsuccessful case - Mistype of username (space after name):

    backus: cookie @WOLVES
    #Wolf Pup doesn't see 'WOLVES ' in room and eats cookie himself
----------------------
#####__Command__: `punish`
#####_Description_:
Fun command for 'punishing' users.
#####_Syntax_: 

Command:

    punish @user

Parameters:

    @user    Recipient of punishment

#####_Example_:

Successful case:

    backus: punish @WOLVES
    #Wolf Pup pinches @WOLVES's nipples super hard

Unsuccessful case - Non existant user:

    backus: punish @NonExistantUser
    #Wolf Pup punishes @backus for getting the syntax wrong.
    #Wolf Pup: Seriously though, I don't recognize the username 'NonExistantUser'
----------------------
#####__Command__: `.128`
#####_Syntax_: 

Command:

    .128

#####_Example_:

Flagging song for bad quality:

    backus: .128
    #Wolf Pup: Flagged for bad sound quality. Where do you get your music? The garbage can? Don't play this low quality tune again!
----------------------
#####__Command__: `/lock`
#####_Description_:
Locks the DJ booth.
#####_Syntax_: 

Command:

    /lock

#####_Example_:

Locking the booth:

    backus: /lock
    #Wolf Pup: Pop and lock dat ish
    #Wolf Pup locked the DJ booth.
----------------------
#####__Command__: `/unlock`
#####_Description_:
Unlock the booth if its locked.
#####_Syntax_: 

Command:

    /unlock

#####_Example_:

Unlocking the booth:

    backus: /unlock
    #Wolf Pup: You'll never get the key to unlock my heart
    #Wolf Pup unlocked the DJ booth.
----------------------
#####__Command__: `/swap`
#####_Description_:
Swap out a user for another user on deck.  Bot locks deck, removes user1, adds user2, and then unlocks deck again.
#####_Syntax_: 

Command:

    /swap @USER1 for @USER2

Parameters:

    @USER1    User you want to remove
    @USER2    User to add to deck 

#####_Example_:

Swapping 2 users (removing me0w and adding Jerm):

    backus: /swap @me0w for @Jerm
    #Wolf Pup locked the DJ booth.
    #Wolf Pup: Removing me0w...
    #Wolf Pup removed me0w from the DJ booth.
    #Wolf Pup: Adding Jerm...
    #Wolf Pup added Jerm to the DJ booth.
    #Wolf Pup unlocked the DJ booth.
----------------------
#####__Command__: `/pop`
#####_Description_:
Remove the last person on deck.  Useful if you lock the deck and then have to remove the person who just played a song.
#####_Syntax_: 

Command:

    /pop

#####_Example_:

Removing user (Sticky Overflow) from deck:

    backus: /pop
    #Wolf Pup removed Stick Overflow from the DJ booth.
----------------------
#####__Command__: `/push`
#####_Description_:
Push a new user onto the stage. Usually used after `/pop`ing a user off the stage.
#####_Syntax_: 

Command:

    /push @User

Parameters:

    @User    User to add to DJ booth

#####_Example_:

Pushing user (Matthias) on to the stage:

    backus: /push @Matthias
    #Wolf Pup added Matthias to the DJ booth.
----------------------
#####__Command__: `/skip`
#####_Description_:
Skip the current song.
#####_Syntax_: 

Command:

    /skip

#####_Example_:

Skipping a song:

    backus: /skip
    #Wolf Pup skipped the current DJ.
----------------------
#####__Command__: `/resetafk`
#####_Description_:
Reset AFK time (to prevent user from being removed).  Useful for protecting VIPs
#####_Syntax_: 

Command:

    /resetafk @user

Parameters:

    @user    User who you want to reset AFK time for

#####_Example_:

Reset example usage:

    backus: /resetafk @MistaDubstep
    #Wolf Pup: @MistaDubstep's AFK time has been reset.
----------------------
#####__Command__: `/protect`
#####_Description_:
Protect a user (usually a VIP) from being removed from deck or kicked from room.
#####_Syntax_: 

Command:

    /protect @user

Parameters:

    @user    User you want to prevent bot from removing and kicking

#####_Example_:

Example protection:

    backus: /protect @Klaypex
    #Wolf Pup: I shall protect you @Klaypex (I wont kick or remove you)
----------------------
#####__Command__: `/dclookup`
#####_Description_:
If a user disconnects from the room while on the waitlist, you can see where they were in line.
#####_Syntax_: 

Command:

    /dclookup @user

Parameters:

    @user    Recently disconnected user you want to see data from

#####_Example_:

Disconnect lookup for user not previously on waitlist:

    backus: /dclookup @Deki
    #Wolf Pup: Deki has disconnected 1 time. Their most recent disconnect was at 11:06 AM (7 songs ago). They were not on the waitlist.

Disconnect lookup for user that was on waitlist:

    backus: /dclookup @JoseLeNerd
    #Wolf Pup: JoseLeNerd has disconnected 1 time. Their most recent disconnect was at 2:14 PM (3 songs ago). They were 2 songs away from the DJ booth.
---------------------- 
#####__Command__: `/voteratio`
#####_Description_:
See how many times any person has woot'd and meh'd since the bot was last launched
#####_Syntax_: 

Command:

    /voteratio @user

Parameters:

    @user    User you want to lookup vote history for

#####_Example_:

Vote ratio lookup:

    backus: /voteratio @Panda Attack
    #Wolf Pup: Panda Attack has wooted 9 times, and meh'd 1 time. Their woot:vote ratio is 0.90.
----------------------
####User Commands
----------------------
#####__Command__: `hug`
#####_Description_:
Hugs for fun why not.
#####_Syntax_: 

Command:

    hug [bot name]

Parameters:

    [bot name]    Name of bot set in settings

#####_Example_:

Ex Case:

    backus: hugs pup
    #Wolf Pup: hugs @backus
----------------------
#####__Command__: `taco`
#####_Description_:
Bot gives out tacos
#####_Syntax_: 

Command:

    taco

#####_Example_:

Taco example:

    backus: taco
    #Wolf Pup: Yo @backus, here is your Fish Taco!
----------------------
#####__Command__: `/newsongs`
#####_Description_:
Provide new channels for users to discover music through. To cut down on overplayed songs.
#####_Syntax_: 

Command:

    /newsongs

#####_Example_:

New songs example:

    backus: /newsongs
    Everyone's heard that Flux Pavilion track! Get new music from 
    http://youtube.com/UndergroundDubstep http://youtube.com/ClownDubstep 
    or http://youtube.com/LessThan3Dubstep
----------------------
#####__Command__: `/whywoot`
#####_Description_:
Tell users why they should woot
#####_Syntax_: 

Command:

    /whywoot

#####_Example_:

Usage:

    backus: /whywoot
    #Wolf Pup: We dislike AFK djs. We calculate your AFK status by checking the last time you spoke. If you don't chat or vote every 12 minutes, I'll automagically remove you.
----------------------
#####__Command__: `/whymeh`
#####_Description_:
A command that tells users when and when not to meh.  Customize based on room.
#####_Syntax_: 

Command:

    /whymeh

#####_Example_:

Why meh usage:

    backus: /whymeh
    #Wolf Pup: Reserve Mehs for songs that are a) extremely overplayed b) off genre c) absolutely god awful or d) troll songs. If you simply aren't feeling a song, then remain neutral
----------------------
#####__Command__: `/theme`
#####_Description_:
Theme macro command.  Should be customized depending on room.
#####_Syntax_: 

Command:

    /theme

#####_Example_:

Theme usage:

    backus: /theme
    #Wolf Pup: Any type of Bass Music is allowed here. Including Dubstep, Drum and Bass, Hardstyle/Hardcore, Moombahton, Trap, Garage, EDM/House Music, Trance, etc
----------------------
#####__Command__: `/rules`
#####_Description_:
Rules macro.  Should be customized for room.
#####_Syntax_: 

Command:

    /rules

#####_Example_:

Rules usage:

    backus: /rules
    #Wolf Pup: 1) Play good sound quality music. 2) Don't replay a song on the room history. 3) Max song limit 8 minutes. 4) DO NOT GO AWAY FROM KEYBOARD ON DECK! Please chat every once in awhile to show you're there!
----------------------
#####__Command__: `/roomhelp`
#####_Description_:
Room help macro. Customize me.
#####_Syntax_: 

Command:

    /roomhelp

#####_Example_:

Room help usage:

    backus: /roomhelp
    #Wolf Pup: Welcome to the Dubstep Den! Create a playlist and populate it with songs from either YouTube or Soundcloud. Click the 'Join Waitlist' button and wait your turn to play music. Most electronic music allowed, type '/theme' for specifics.
    #Wolf Pup: Stay active while waiting to play your song or I'll remove you. Play good quality music that hasn't been played recently (check room history). To prevent lag type /cap 50. Ask a mod if you're unsure about your song choice
----------------------
#####__Command__: `/source`
#####_Description_:
Share source information with people. Please don't delete this, I worked hard on this bot.
#####_Syntax_: 

Command:

    /source

#####_Example_:

Source command usage:

    backus: /source
    #Wolf Pup: John Backus (http://johnback.us/) wrote me in CoffeeScript. A generalized version is available here: https://github.com/backus/Plug.DJ-Javascript-Chatbot
----------------------
#####__Command__: `/download`
#####_Description_:
Create a google search query with a couple popular download sites for the current song + artist playing.
#####_Syntax_: 

Command:

    /download

#####_Example_:

Example download command (For song 'Zombies Ate My Neighbors (HQ)' by Schoolboy:

    backus: /download
    #Wolf Pup: Try this link for HIGH QUALITY DOWNLOAD: http://google.com/#hl=en&q=Schoolboy%20-%20Zombies%20Ate%20My%20Neighbors%20(HQ)%20site%3Azippyshare.com%20OR%20site%3Asoundowl.com%20OR%20site%3Ahulkshare.com%20OR%20site%3Asoundcloud.com
----------------------
#####__Command__: `/afks`
#####_Description_:
List current djs on stage that are AFK >8m.
#####_Syntax_: 

Command:
    /afks

#####_Example_:

AFK usage:

    backus: /afks
    #Wolf Pup: AFKs: me0w - 9m2s. Jerm - 13m12s.
----------------------
#####__Command__: `/allafks`
#####_Description_:
List of all users that are AFK in the room >10 minutes.
#####_Syntax_: 

Command:

    /allafks

#####_Example_:

All afk usage example:

    backus: /allafks
    #Wolf Pup: AFKs: Astro - 4h52m14s. ACiD GRiM - 4h8m32s. Christian Larsson Boysen - 2h56m4s. deaf DJ - 5h4m56s. Dj Andie - 6h22m24s. DJ Jelení Zobák - 9h30m30s. Dj Leo Wolf - 1d2m48s. DJ-Braba - 11h48m3s. Driven - 1d4h50m48s. DubSNOW - 1d3h47m3
----------------------
#####__Command__: `/status`
#####_Description_:
Uptime information for bot.
#####_Syntax_: 

Command:

    /status

#####_Example_:

Status usage:

    backus: /status
    #Wolf Pup: Initiated 9/2 13:55 PM. 408 songs have been played, accumulating 18827 woots, 288 mehs, and 620 queues.
----------------------
#####__Command__: `/commands`
#####_Description_:
List available commands for the user that calls command's user class. Different results for users, mods, and host.
#####_Syntax_: 

Command:

    /commands

#####_Example_:

When called by moderator:

    backus: /commands
    #Wolf Pup: hugs pup, taco, cookie, punish, /newsongs, /whywoot, /theme, /rules, /roomhelp, /source, /sourcecode, /author, /woot, .128, /tableflip, /tablefix, /download, /smokesesh, /smoke, /dab, /afks, /allafks, /status, /lock, /unlock, /swap, /pop, /push, /whymeh, /skip, /commands, /resetafk, /cmdhelp, /protect, /dclookup, /voteratio, /avgvoteratio

When called by user:

    Deki: /commands
    #Wolf Pup: hugs pup, taco, cookie, /newsongs, /whywoot, /theme, /rules, /roomhelp, /source, /sourcecode, /author, /woot, /tableflip, /tablefix, /download, /afks, /allafks, /status, /whymeh, /commands, /cmdhelp
----------------------
#####__Command__: `/cmdhelp`
#####_Description_:
For more information on specific commands
#####_Syntax_: 

Command:

    /cmdhelp [Command]

Parameters:

    Command    The name of any other command that the user wants info on

#####_Example_:

Using /cmdhelp for /theme:

    backus: /cmdhelp /theme
    #Wolf Pup: Learn what genres of music are generally accepted here.
----------------------
###Writing New Commands
_Prerequisite_:  Basic understanding of Coffeescript, Javascript, and Object Oriented programming.
####Writing and implementing a simple command
#####Facebook group command

For the sake of learning how to add new commands to the bot, lets add a 'Join our Facebook Group' command.
Our command will:
* Be available to all users
* Will be called by typing `/fb`
* Will share the message 'If you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S'

######Part 1: Writing new command with existing bot command API
All commands for the bot called by users are located in the `commands` directory.  Our command will be called with `/fb`, so lets name the file `fb.coffee`.

In `fb.coffee` we first declare the new command with a line like:
    
    class fbCommand extends Commmand

This bot API has a base `Command` class that handles basic parsing and [ACL Permissions](http://en.wikipedia.org/wiki/Access_control_list).  Thanks to this class, we just need to define 3 variables when we initialize:
* `@command`
* `@parseType`
* `@rankPrivelege`

`@command` is the name of the command we are writing. We want our command to be called with the command `/fb`, so we set `@command` to `'/fb'`.

`@parseType` offers three parsing options: `exact`, `startsWith`, and `contains`.
* `exact` requires the users message to be exactly @command's value.  In this case, we want to use `exact`. 
* `startsWith` only requires that the users message begin with @command's value.  This is useful if, for example, you want to parse out a parameter like a username or a setting.
  * If we used `startsWith` for this command, then our command would be called if users type (for example), `/fb is a command`. That's not really what we want. 
* `contains` only requires that the @command's value is in the user's message.
  * This would mean that a user that said `What does /fb do?` would trigger the command.  Clearly not ideal.

`@rankPrivelege` specifies the _minimum_ user class level required for the command to be triggered.  We want everyone to see our facebook page, so we set `@rankPrivelege` to `'user'`.  The other options are `mod` and `host`.

We need to put the 3 variables we've gone over in the `init` function of our `fbCommand` class.  Therefore, our current code should look like this:

`fb.coffee`:

```Coffeescript
class fbCommand extends Command
    init: ->
        @command='/fb'
        @parseType='exact'
        @rankPrivelege='user'
```

The final steps for this command are simple thanks to the underlying logic of the `Command` base class.  If our requirements for this command are met (User's message is _exactly_ `'/fb'`), then the class will call the method `functionality` which we have to define.

All our command needs to do right now is respond with a simple message and a link to the group, so we can just define a response and use [Plug.DJ's API](http://blog.plug.dj/api-documentation/) to send the message.

So if we define our response as `resp = 'If you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S'` and use Plug's `API.sendChat` our finalized file should look like:

`fb.coffee`:

```Coffeescript
class fbCommand extends Command
    init: ->
        @command='/fb'
        @parseType='exact'
        @rankPrivelege='user'

    functionality: ->
        resp = 'If you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S'
        API.sendChat resp
```

######Part 2: Include new command where necessary

After completing our `/fb` command as per [Part 1](#part-1-writing-new-command-with-existing-bot-command-api), we need make two more modifications to the bot.  

First, we need to add the new commands file to our Coffeescript build file in the `appFiles` array.  Truncated example:

`Cakefile`:

    fs     = require 'fs'
    {exec} = require 'child_process'

    appFiles  = [
      # omit src/ and .coffee to make the below lines a little shorter
      'settings'
      'user'
      'room_helper'
      
      ...

      'commands/commands'
      'commands/disconnect_lookup'
      'commands/fb'           ## Our new facebook command's file include!
      'commands/vote_ratio'
      'commands/average_vote_ratio'
      'chat_commands'

      ...

And then we also need to open up `chat_commands.coffee` and add the class name to the array of commands, so that the chat dispatcher knows to test new messages for our new command.  Just like we included our fb.coffee file after the file for the `/dclookup` command, we can include our new class right after the `disconnectLookupCommand` class in the chat_commands array:

`chat_commands.coffee`:
  
      ...

      forceSkipCommand,
      fbCommand,
      cmdHelpCommand,
      protectCommand,
      disconnectLookupCommand,
      fbCommand,              ## Our new facebook command's class!
      voteRatioCommand,
      avgVoteRatioCommand
    ]

If we've done everything right, we should be able to compile and run our code (explained in [Compile How To Section](#how-to-compile-and-run)) and use our new command as such:

    backus: /fb
    #Wolf Pup: If you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S

Piece of cake!

######Part 3: Extending command to do more!

If you liked making your new command and want to do more, I'll show you a few more tricks.

__Multiple names for same command__:

Say you want users to be able to say `/fb`, `/facebook`, or `/group`.  Instead of creating 3 new files, you can simple pass an array of commands to the @command variable.  As a result, our init method would look like:

`fb.coffee`:

```Coffeescript
class fbCommand extends Command
  init: ->
    @command='/fb'
    @parseType='exact'
    @rankPrivelege='user'
```

__Random different responses to command__:

This is how I have our `/fb` command configured in the Dubstep Den.  Simply include an array of messages in your fbCommand class, and use Javascript's `Math` library to randomly choose one of the messages.  Here is my code (I use {fb} in the messages and `.replace` so I only have to hardcode in the URL once):

```Coffeescript
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
```

__@Mention user that triggered command__:

Within the `functionality` method, the variable `@msgData` is available with all the information supplied by Plug.DJ's API's message event.  If we wanted interaction like this:

    backus: /fb
    #Wolf Pup: @backus, if you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S

Then we would write the functionality command like so:

```Coffeescript
functionality: ->
    fromName = @msgData.from
    resp = '@' + fromName + ', if you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S'
    API.sendChat resp
```

__@Mention another user passed to command__:

For functionality like:

    backus: /fb @WOLVES
    #Wolf Pup: @WOLVES, if you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S

That @mentions a user passed to the command _if_ the name supplied is the name of a user in the room, then we would combine some string parsing of our own with the help of the RoomHelper class's user lookup command:

```Coffeescript
init: ->
  @command='/fb'
  @parseType='startsWith'
  @rankPrivelege='user'

functionality: ->
  msg = @msgData.message #actual message supplied by message event
  r = new RoomHelper() #introduce RoomHelper for user lookup functionality
  if msg.length > 5 #message is longer than just '/fb', so may include username
    name = msg.substr(5)#trims string from '/fb @backus' to 'backus'
    user = r.lookupUser(name)#Search users in room for user with specified name
    if user == false#if no users with name provided found
      API.sendChat "/em doesn't see '"+msg.substr(8)+"' in room" #response message for no user
      return false
    else # Respond with found user's username
      API.sendChat "@"+user.username+", if you like the dubstep den, then join our facebook group! http://on.fb.me/HNzK5S"
```


##How to compile and run

To compile the bot, you will need to install [Node.JS](http://nodejs.org/) and then `npm install coffeescript`.

When you have coffeescript installed on your system, just open up a terminal/command prompt window, CD to your bot file main directory, and type `cake build`.  Examples:

Windows:

    C:\Users\Backus\coding\Plug.DJ-Javascript-Chatbot>cake build

    Done

Linux:

    john@backus-laptop:/var/www/Plug.DJ-Javascript-Chatbot$ cake build

    Done

The final javascript file should be output in 

    Plug.DJ-Javascript-Chatbot/bin/bot.js

Then you can either include the file locally, or put it on a server, and inject the javascript file in your browser.  I usually put my script on my server so I can utilize the `/reload` functionality.

Once you know where you are including your `bot.js` file from, you can simply type:

    javascript:$.getScript('[YOUR INCLUDE LOCATION]');

Into your web browser.  My file is usually on my server at `http://johnback.us/js/bot.js`, so my include would be:

    javascript:$.getScript('http://johnback.us/bot.js');

That's all!