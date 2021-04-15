/*
OFFICALLY SCRIPTED BY BO$$
VERSION - 0.1
//--------------------------------[B-Discord filterscript]--------------------------------


 * Copyright (c) 2020, Bo$$ Filterscripts.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are not permitted in any case.
 *
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <a_samp>
#include <bcolors>
#include <discord-connector>
#include <geoip>
#include <zcmd>
#include <foreach>
//#include <discord-command>
#include <BCMD1>
/*
#define BCMD_PREFIX '!' //If you don't define, by default it is '!'
#define BCMD_STRICT_CASE //Defining this will make commands case-sensitive. !test and !TEST will become different
#define BCMD_ALLOW_BOTS //Defining this will not ignore commands sent on channel by bots.
*/
new DCC_Channel:Server_Connect; // Server connection
new DCC_Channel:Player_Connect; // Player connection
new DCC_Channel:Player_Disconnect; //Player disconnection
new DCC_Channel:Command_Logs; //Command Logs
new DCC_Channel:Player_Chat; //Player chats


public OnFilterScriptInit()
{	
	Server_Connect = DCC_FindChannelById( "824838522304331776");

	Player_Connect = DCC_FindChannelById( "824838522304331776");

	Player_Disconnect = DCC_FindChannelById( "824838522304331776");

	Command_Logs = DCC_FindChannelById("824838522304331776");

	Player_Chat = DCC_FindChannelById("824838522304331776");
	
	new string[128];
	format(string,sizeof string,"Server succesfully started");
	DCC_SendChannelMessage(Server_Connect,string);
	return 1;

}
public OnPlayerConnect(playerid)
{
	new name1[MAX_PLAYER_NAME];
	new pip[16],pcountry[16];
	GetPlayerIp(playerid, pip, sizeof(pip));
	GetPlayerCountry(playerid, pcountry,sizeof(pcountry));
	GetPlayerName(playerid, name1, sizeof(name1));
	new string[128];
	format(string,sizeof string,"%s Joined the server with ip %s and country %s",name1,pip,pcountry);
	DCC_SendChannelMessage(Player_Connect,string);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	new name1[MAX_PLAYER_NAME];
	new string[128];
	GetPlayerName(playerid, name1, sizeof(name1));
	format(string,sizeof string,"%s disconnected from the server",name1);
	DCC_SendChannelMessage(Player_Disconnect,string);
	return 1;
}
forward DCC_OnMessageCreate(DCC_Message:message);
public DCC_OnMessageCreate(DCC_Message:message)
{
    new realMsg[100];
    DCC_GetMessageContent(message, realMsg, 100);
    new bool:IsBot;
    new DCC_Channel:channel;
    DCC_GetMessageChannel(message, channel);
    new DCC_User:author;
    DCC_GetMessageAuthor(message, author);
    DCC_IsUserBot(author, IsBot);
    if(channel == Player_Chat && !IsBot) //!IsBot will block BOT's message in game
    {
        new user_name[32 + 1], str[152];
        DCC_GetUserName(author, user_name, 32);
        format(str,sizeof(str), "{8a6cd1}[DISCORD] {aa1bb5}%s: {ffffff}%s",user_name, realMsg);
        SendClientMessageToAll(-1, str);
    }
    return 1;
}
public OnPlayerText(playerid, text[])
{
	new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);
    new msg[128];
    format(msg, sizeof(msg), "```%s(%d): %s```", name, playerid, text);
    DCC_SendChannelMessage(Player_Chat, msg);
    return 1;
  
}
//TEST COMMAND//
CMD:freeze(playerid,params[])
{
	new targetid;
	if(IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_GREEN,"You can't use this command");
	TogglePlayerControllable(targetid, 0);
	SendClientMessage(playerid, COLOR_GREEN,"Player is not freezed");
	Bosslogs(playerid,"freeze");// THIS LINE WILL REPRESENT THE LOGS SYSTEM 
	return 1;

}
public OnDiscordCommandPerformed(DCC_User:user, DCC_Channel:channel, cmdtext[], success) {

    if(!success) {
    
        DCC_SendChannelMessage(channel, "This command does not exist!");
    }
    return 1;
}
BCMD:info(user, channel, params[]) 
{
		DCC_SendChannelMessage(channel, "> **__IP - YOUR SERVER IP__**\n> **__Gamemode - YOUR GAMEMODE__** \n> **__Server Slot - SERVESLOT__** \n> **__Language - SERVERLANGUAGE__** \n> **Forums - FORUMS ** \n> **" );
		return 1;
}
stock Bosslogs(playerid, command[])
{
  new name1[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name1, sizeof(name1));
  new string[128];
  format(string, sizeof string, "[ADM.CMD] Administrator %s[%i] has used /%s", name1, playerid, command);
  DCC_SendChannelMessage(Command_Logs, string);
}
BCMD:test(user, channel, params[]) {

    DCC_SendChannelMessage(channel, "Hello from server!");
    return 1;
}

BCMD:cmds(user, channel, params[]) 
{

		DCC_SendChannelMessage(channel, "YOUR COMMANDS" );
		return 1;
}

BCMD:players(user, channel, params[]) 
{

		new iPlayers = Iter_Count(Player);
		new playerid;
		new count = 0;
		new name69[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name69, sizeof(name69));
		new szBigString[ 0 ] = '\0';
		if ( iPlayers <= 30 )
		{
		foreach(new i : Player) {
			if ( IsPlayerConnected( i ) ) {
				format( szBigString, sizeof( szBigString ), "%s%s (ID: %d)\n", szBigString, name69, playerid );
				count++;
			}
		}
		}
		format( szBigString, sizeof( szBigString ), "%sThere are %d player(s) online.", szBigString, count );
		DCC_SendChannelMessage( channel, szBigString );
		return 1;
}
BCMD:say(user, channel, params[]) {

    if(isnull(params)) {
        DCC_SendChannelMessage(channel, "SYNTAX: !say [msg]");
    } else {

        new str[144], username[33];
        DCC_GetUserName(user, username, sizeof(username));
        format(str, sizeof(str), "[DISCORD] %s says: %s", username, params);
        SendClientMessageToAll(-1, str);
    }
    return 1;
}

