 /*
	Discord Command Processor

	A simple library for discord based commands
	with iZCMD-like code and functionality. Does
	not require any additional libraries. Simple.

	Author:
	- AliLogic
    Fixed by 
    - Bo$$
    This discord-command was showing some warnings which was fixed by Bo$$.
    This include will be used in B-Discord filterscript.
	Version:
	- 0.3.0
*/

// Include guard

#if defined _discordcmd_included
	#endinput
#endif
#define _discordcmd_included

#tryinclude <discord-connector>
#if !defined dcconnector_included
	#error To use this include you need to have "https://github.com/maddinat0r/samp-discord-connector" installed
#endif

// Config

#define MAX_CMD_LEN			(50)
#define MAX_CMD_NAME		(10)

// Prefix

#if	!defined CMD_PREFIX
	#define	CMD_PREFIX		'!'
#endif

// Macros

#define DISCORD:%1(%2)		\
	forward discord_%1(%2);	\
	public discord_%1(%2)

#define DC:%1(%2) 			\
	DISCORD:%1(%2)

// Command result

#define DISCORD_SUCCESS		(1)
#define DISCORD_FAILURE		(0)

// Code
forward DCC_OnChannelMessage(DCC_Channel:channel, DCC_User:author, const message[]);
public DCC_OnChannelMessage(DCC_Channel:channel, DCC_User:author, const message[]) {
	new
		bool: is_bot;

	DCC_IsUserBot(author, is_bot);

	if (!is_bot && message[0] == CMD_PREFIX) { // Skip if the message author is a bot or is not a command

		new // static had issues
			discord[MAX_CMD_LEN] = "discord_",
			pos;

		if ((pos = strfind(message, " ", false, 1)) == -1) { // Space was not found

			strcat(discord, message[1], MAX_CMD_LEN - 8);

			#if defined OnDiscordCommandPerformed
				OnDiscordCommandPerformed(channel, author, bool: CallLocalFunction(discord, "iis", _: channel, _: author, "\1"));
			#else
				CallLocalFunction(discord, "iis", _: channel, _: author, "\1");
			#endif

		} else { // Space was found

			strcat(discord, message[1], pos + 8);

			while (message[pos] == ' ') { // Checks for spaces

				pos ++;
			}

			if (message[pos]) { // Parameter was found

				#if defined OnDiscordCommandPerformed
					OnDiscordCommandPerformed(channel, author, bool: CallLocalFunction(discord, "iis", _: channel, _: author, message[pos]));
				#else
					CallLocalFunction(discord, "iis", _: channel, _: author, message[pos]);
				#endif

			} else { // Parameter was not found

				#if defined OnDiscordCommandPerformed
					OnDiscordCommandPerformed(channel, author, bool: CallLocalFunction(discord, "iis", _: channel, _: author, "\1"));
				#else
					CallLocalFunction(discord, "iis", _: channel, _: author, "\1");
				#endif
			}
		}
	}	
	
	#if defined discdcmd_DCC_OnChannelMessage
		return discdcmd_DCC_OnChannelMessage(DCC_Channel: channel, DCC_User: author, message);
	#else
		return 1;
	#endif
}

// Hooking and callbacks

#if defined _ALS_DCC_OnChannelMessage
	#undef DCC_OnChannelMessage
#else
	#define _ALS_DCC_OnChannelMessage
#endif

#define DCC_OnChannelMessage discdcmd_DCC_OnChannelMessage
#if defined discdcmd_DCC_OnChannelMessage
	forward discdcmd_DCC_OnChannelMessage(DCC_Channel: channel, DCC_User: author, const message[]);
#endif

#if defined OnDiscordCommandPerformed
	forward OnDiscordCommandPerformed(DCC_Channel: channel, DCC_User: author, bool: success);
#endif