Plug.DJ Moderation Helper Bot
==========================
Written by John Backus - http://johnback.us/

#Overview
This bot is written to help:

1. Automate certain aspects of room moderation
2. Provide moderators additional tools to make their job easier
3. Track certain room statistics to optimize DJing experience (AFK status, vote ratios, disconnect logs)
4. Be fun to use

For more information, visit the [Wiki](https://github.com/backus/Plug.DJ-Javascript-Chatbot/wiki):

1. [Full Bot Command Reference](https://github.com/backus/Plug.DJ-Javascript-Chatbot/wiki/Bot-Commands-Overview)
2. [Tutorial: Writing New Commands](https://github.com/backus/Plug.DJ-Javascript-Chatbot/wiki/Tutorial:-Writing-New-Commands)

#Bot Features
--------------
###Moderation Automation

####AFK Monitor
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
    
####Forceskip Song Override
* Problem: Plug.DJ's _Triangles of Death_ bug
  * When this bug occurs, instead of moving on to the next song when a DJ's track ends, the triangle animation plays indefinitely until a moderator or the DJ skips.
    * If this bug occurs, and the room doesn't have a bot or moderators dilligently skipping, the room slips into silence and nearly all active users leave.
* Solution
  * With the help of the bot, the room host can type: `/forceskip enable` and the bot will auto-skip every song as soon as it ends.

####Anti-Spam Handler
* Problem: People spam links in your room
  * When your room reaches to top, other rooms try to steal users by spamming their room link in your room.
* Solution
  1. Plug.DJ introduced a simple anti-spam solution: Messages that include room links sent by users that joined the room <5 minutes earlier are not displayed to other users.
  2. The bot deletes messages sent by non-moderators that include links to other rooms.
* A word of caution
  * The bot *can* be configured to kick users that link plug.dj rooms, but here is why I don't recommend this solution:
    * What happened when [Klaypex](https://www.facebook.com/Klaypex) wanted to promote our room: http://johnback.us/img/Bot_Fail.png

####Interval based room announcements
* If you have a facebook group link you would like to share, or any message you would like to regularly announce, the bot can be configured to say a certain message every X number of songs.

###Host/Moderator tools
------------------------
####Waitlist Disconnect Monitor
* For whatever reason, users sometimes disconnect from Plug.DJ rooms.  This sucks if they have been on a waitlist to play a song for over an hour 
* Solution:
  * The bot monitors the room's waitlist and DJ stand.  If a user disconnects from the room while on the stage or on the waitlist, it logs their disconnect.  Mods can use a command to check disconnects.
  * Mod command usage example:
    
Dimi looking up my disconnect:

    Ɖimi: /dclookup @backus
    #Wolf Pup: backus has disconnected 1 time. Their most recent disconnect was at 10:29 AM (2 songs ago). 
    They were 4 songs away from the DJ booth.
    

####Visitor tracking
* Users are welcomed when they join the room.
* Each unique user is stored within the bot in their own user object, and flagged as offline in object if they disconnect. This way, vote statistics and similar data can be stored about a user even after the disconnect and reconnect.


####Booth controls
* The bot simplifies the process of locking and unlocking the booth, adding and removing users, and swapping users with:
  * `/lock`
  * `/unlock`
  * `/pop`
  * `/push @user`
  * `/swap @user_to_remove for @user_to_add`


####AFK Override Commands
* For special circumstances, a mod can reset a user's AFK time using `/afkreset @user`
* For VIPs, `/protect @user` ensures they won't be kicked or removed for being AFK


####New song recommendation
* A list of youtube channels with new music can be configured for recommending to new visitors that play overplayed songs.
* Example:

A user plays overplayed song:

    *Panda Attack started playing 'Scary Monsters and Nice Sprites' by Skrillex*
    backus: /newsongs
    #Wolf Pup: Everyone's heard that Skrillex track! Get new music from http://youtube.com/MistaDubstep http://youtube.com/UndergroundDubstep or http://youtube.com/JitterStep

####Roomhelp, Theme, Vote Rules, Bad Quality Flag
* Configure commands (and create new commands) for automating frequently explained messages.
* By default, the bot comes with:
  * `/roomhelp` - Inform new users how the room works
  * `/whywoot` - Teach users why voting is important to show that they are active
  * `/whymeh` - Tell users that Meh'ing should be saved for songs they really hate
  * `/theme` - Notify users what genres are allowed
  * `/source` - Share with users who created this bot.

###Statistics
----------------
* User Vote Monitor
  * The bot tracks how every user votes for each song.
  * This is useful for users that Meh way more than others.
  * Lookup vote stats example:

Dimi looks up DJ P0N-3's vote stats:

    Ɖimi: /voteratio @DJ P0N-3
    #Wolf Pup: DJ P0N-3 has wooted 88 times, and meh'd 4 times. Their woot:vote ratio is 0.95.
    

#How to compile and run
------------------------------
To compile the bot, you will need to install [Node.JS](http://nodejs.org/) and then `npm install coffeescript`.

When you have coffeescript installed on your system, just open up a terminal/command prompt window, CD to your bot file main directory, and type `cake build`.  Examples:

Windows:

```console
C:\Users\Backus\coding\Plug.DJ-Javascript-Chatbot>cake build

Done
```

Linux:

```console
john@backus-laptop:/var/www/Plug.DJ-Javascript-Chatbot$ cake build

Done
```

The final javascript file should be output in 

    Plug.DJ-Javascript-Chatbot/bin/bot.js

Then you can either include the file locally, or put it on a server, and inject the javascript file in your browser.  I usually put my script on my server so I can utilize the `/reload` functionality.

Once you know where you are including your `bot.js` file from, you can simply type:

```Javascript
javascript:$.getScript('[YOUR INCLUDE LOCATION]');
```

Into your web browser.  My file is usually on my server at `http://johnback.us/js/bot.js`, so my include would be:

```Javascript
javascript:$.getScript('http://johnback.us/bot.js');
```

That's all!