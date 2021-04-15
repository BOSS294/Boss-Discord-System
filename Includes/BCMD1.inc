/*
________________________________________________________________________________
						B-discord-command.inc
			Command processor for SA-MP Discord Connector
@Author			:		Bo$$ 
@Version        :       v0.1   
________________________________________________________________________________    */

#if defined _included_discord_command
	#endinput
#endif

#define _included_discord_command

#if !defined BCMD_PREFIX
	#define BCMD_PREFIX '!'
#endif


#define BCMD:%0(%1,%2,%3) \
	forward BCMD_%0(DCC_User:%1,DCC_Channel:%2,%3); \
	public BCMD_%0(DCC_User:%1,DCC_Channel:%2,%3)

#if !defined isnull
	#define isnull(%0) (!(%0[0]) || (%0[0] == '\1' && !(%0[1])))
#endif


#tryinclude <discord-connector>

#if defined BCMD_STRICT_CASE
	static const BCMD_MAX_CMD_LEN = 32 - 5;
#endif
const BCMD_TOTAL_CMD_SIZE = 256;

#if defined OnDiscordCommandAttempt
	forward OnDiscordCommandAttempt(DCC_User:user, DCC_Channel:channel, cmdtext[]);
#endif

#if defined OnDiscordCommandPerformed
	forward OnDiscordCommandPerformed(DCC_User:user, DCC_Channel:channel,
										cmdtext[], success);
#endif

static DCC_Message:g_BCMDMessageID = DCC_Message:0;

stock DCC_Message:BCMD_GetCommandMessageId() {

	return g_BCMDMessageID;
}

public DCC_OnMessageCreate(DCC_Message:message) {

	new
		DCC_User:user,
		DCC_Channel:channel,
		cmdtext[BCMD_TOTAL_CMD_SIZE],
		bool:hasParams = false,
		bool:isBot;

	DCC_GetMessageContent(message, cmdtext, sizeof(cmdtext));
	if(cmdtext[0] == BCMD_PREFIX) {

		DCC_GetMessageAuthor(message, user);
		DCC_GetMessageChannel(message, channel);

		DCC_IsUserBot(user, isBot);
		#if !defined BCMD_ALLOW_BOTS
			if(isBot)
				return 0;
		#endif
		g_BCMDMessageID = message;
		#if defined OnDiscordCommandAttempt
			if(!OnDiscordCommandAttempt(user, channel, cmdtext[1]))
				return 0;
		#endif

		static command[32] = "BCMD_", success = 0;
		new pos;
		#if defined BCMD_STRICT_CASE
			pos = strfind(cmdtext, " ", false, 1);
			command[5] = '\0';
			if(pos != -1) {

				strcat(command, cmdtext[1], pos + 5);
				while(cmdtext[pos] == ' ') ++pos;
				if(cmdtext[pos]) {
					hasParams = true;
				}
			} else {
				strcat(command, cmdtext[1], BCMD_MAX_CMD_LEN);
			}
		#else
			new idx = 5;
			pos = 1;
			while(idx < 31 && cmdtext[pos] > ' ') {

				command[idx++] = (
					(cmdtext[pos] >= 'A' && cmdtext[pos] <= 'Z')
					? (cmdtext[pos] | 0x20) : cmdtext[pos]
					);
				pos++;
			}
			command[idx] = '\0';
			while(cmdtext[pos] == ' ') ++pos;
			if(cmdtext[pos]) {
				hasParams = true;
			}
		#endif
		if(hasParams) {
			success = CallLocalFunction(command, "iis",
										_:user, _:channel, cmdtext[pos]);
		} else {
			success = CallLocalFunction(command, "iis",
										_:user, _:channel, "\1");
		}
		#if defined OnDiscordCommandPerformed
			return OnDiscordCommandPerformed(
									user, channel, cmdtext[1], success);
		#else
			return 1;
		#endif
		#pragma unused success
	}
	#if defined BCMD_OnMessageCreate
		return BCMD_OnMessageCreate(message);
	#else
		return 1;
	#endif
}


#if defined _ALS_OnMessageCreate
	#undef DCC_OnMessageCreate
#else
	#define _ALS_OnMessageCreate
#endif

#define DCC_OnMessageCreate BCMD_OnMessageCreate

#if defined BCMD_OnMessageCreate
	forward BCMD_OnMessageCreate(DCC_Message:message);
#endif