Plug.DJ Moderation Helper Bot
==========================
Written by John Backus - http://johnback.us/

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

    enable		Enables bot enforced song skips
    disable		Disables

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
###Writing New Commands

##How to modify

##How to compile and run