/*
OFFICALLY SCRIPTED BY @BO$$
VERSION - 1.4
The include BCMD used is not created by me. I found it on internet.
It was full of errors and bugs.
I fixed it and converted it into BCMD
//--------------------------------[B-Discord Filter-Script]--------------------------------


 * Copyright (c) 2022, Bo$$ Filter Scripts.
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
#include <zcmd>
#include <foreach>
#include <sscanf>
#include <BCMD1>

#define DIALOG_BUGSUGGEST 1234

#define serverconnect       "1096630668894687254"
#define playerconnect       "1096630668894687254"
#define playerdisconnect    "1096630668894687254"
#define commandlogs         "1096630668894687254"
#define playerchat          "1096630668894687254"
#define adminchannel        "1096630668894687254"
#define securitychannel     "1096630668894687254"
#define bugsuggestchannel   "1096630668894687254"
#define randommsgchannel    "1096630668894687254"
#define cordchannel         "1096630668894687254"

new stock                                   //
                                           /////////////////////////////////////////////
     DCC_Channel:Server_Connect,          // Server connection         //
     DCC_Channel:Player_Connect,         // Player connection         /////////////////////////////////
     DCC_Channel:Player_Disconnect,     //Player disconnection       //
     DCC_Channel:Command_Logs,         //Command Logs               ////////////////////////
     DCC_Channel:Player_Chat,         //Player chats               //
     DCC_Channel:Admin_Channel,      //Admins Channel             ///////////////////////////////////
     DCC_Channel:Security_Channel,  // Security Channel          //
     DCC_Channel:BS_Channel,       // bug/suggestion Channel    ///////////////////////////
     DCC_Channel:RM_Channel,      // random message Channel    //
     DCC_Channel:Cord_Channel    // cord saving    Channel    //
                                 /////////////////////////////////////////////////
                                //

;
#define  MAX_QUOTES  5
#define  MAX_MESSAGES 5

 new RandomMSG[][] =
{
    "Hello there!",
    "How are you doing?",
    "Welcome to our server!",
    "Thanks for playing!",
    "Have a great day!"
};

new const quotes[MAX_QUOTES][128] = {
    "```The only way to do great work is to love what you do. - Steve Jobs```",
    "```Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill```",
    "```Believe you can and you're halfway there. - Theodore Roosevelt```",
    "```I have not failed. I've just found 10,000 ways that won't work. - Thomas A. Edison```",
    "```If you want to live a happy life, tie it to a goal, not to people or things. - Albert Einstein```"
};
new random_message_timer;

new bugreport[MAX_PLAYERS];

forward DiscordSendLog(playerid,command[]);
forward DiscordSendLogTarget(playerid,command[],target);
stock DCC_SendChannelMessageFormatted( DCC_Channel: channel, const format[ ]) 
{
    #pragma unused channel
    #pragma unused format
    return 1;
}


stock PlayerName(playerid)
{
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, MAX_PLAYER_NAME);
  return name;
}
forward SendMSG();

public SendMSG()
{
    new randMSG = random(sizeof(RandomMSG));
    DCC_SendChannelMessage(RM_Channel,RandomMSG[randMSG]);

}
#define MAX_CLIENT_MSG_LENGTH 144

public OnFilterScriptInit()
{	
    new string[128],string2[128];
    Server_Connect = DCC_FindChannelById( serverconnect );

    Player_Connect = DCC_FindChannelById( playerconnect );

    Player_Disconnect = DCC_FindChannelById( playerdisconnect );

    Command_Logs = DCC_FindChannelById( commandlogs );

    Player_Chat = DCC_FindChannelById( playerchat );

    Admin_Channel = DCC_FindChannelById( adminchannel );

    Security_Channel = DCC_FindChannelById( securitychannel );
	
    BS_Channel = DCC_FindChannelById( bugsuggestchannel );

    Cord_Channel = DCC_FindChannelById( cordchannel );

    RM_Channel = DCC_FindChannelById( randommsgchannel );



    print("=======================================");
    print("|                                     |");
    print("|        B-Discord version 1.4        |");
    print("|        By Bo$$                      |");
    print("|                                     |");
    print("=======================================");
    SetTimer("SendMSG", 60000, true);
	format(string,sizeof (string),"Server successfully started");
	DCC_SendChannelMessage(Server_Connect,string);
	SetTimer("BotStatus", 1000, true);
    format(string2,sizeof (string2),"**Bo$$ Security System is in action** :sunglasses:");
    DCC_SendChannelMessage(Security_Channel,string2);
    
	return 1;

}
public OnFilterScriptExit()
{
        KillTimer(random_message_timer);
        return 1;
}
forward BotStatus(playerid);
public BotStatus(playerid)
{
    new iPlayers = Iter_Count(Player);
    new szBigString[1000];
    new count = 0;
    szBigString[ 0 ] = '\0';
    if ( iPlayers <= 30 )
        {
            foreach(new i : Player) 
            {
                if ( IsPlayerConnected( i ) ) 
                {
                    count++;

                }
            }
        }
    if(count == 0)
    {
        format( szBigString, sizeof( szBigString ), "Getting bored ?? Join me at <serverip>", count );
        DCC_SetBotActivity(szBigString);
        DCC_SetBotPresenceStatus(DCC_BotPresenceStatus:ONLINE);
    }
    if(count == 1)
    {
        format( szBigString, sizeof( szBigString ), "There is %d player online.", count );
        DCC_SetBotActivity(szBigString);
        DCC_SetBotPresenceStatus(DCC_BotPresenceStatus:IDLE);
    }
    if(count > 1)
    {
        format( szBigString, sizeof( szBigString ), "There are %d player(s) online.", count );
        DCC_SetBotActivity(szBigString);
        DCC_SetBotPresenceStatus(DCC_BotPresenceStatus:DO_NOT_DISTURB);
    }
}

public OnPlayerConnect(playerid)
{
    
    new pip[100],client1[24];
    GetPlayerIp(playerid, pip, sizeof(pip));
    GetPlayerVersion(playerid, client1, sizeof(client1));
    bugreport[playerid] = 0;
    new string[250];

    format(string,sizeof (string),":white_check_mark: **%s Joined the server**",PlayerName(playerid));
    DCC_SendChannelMessage(Player_Connect,string);
    new str[2048],str2[500], footer[1024];
    format(str, sizeof(str), "Player Connection");
    format(str2,sizeof (str2),"[Security System] {Player-Connected}\nPlayer Name - `%s`\nPlayer id - `%d`\nPlayer ip - `%s`\nClient Version - `V%s` ",PlayerName(playerid),playerid,pip,client1);
    new DCC_Embed:embed = DCC_CreateEmbed(str, str2);
    DCC_SetEmbedColor(embed, 0xFF0000);
    format(footer, sizeof(footer), "Note: This is for security purpose only.");
    DCC_SetEmbedFooter(embed, footer);
    DCC_SendChannelEmbedMessage(Security_Channel, embed);
    SendClientMessage(playerid, COLOR_RED, "This server used B-Discord filterscript by Bo$$");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{

    new string[250];
    format(string,sizeof (string),":no_entry: **%s left the server**",PlayerName(playerid));
    DCC_SendChannelMessage(Player_Disconnect,string);
	return 1;
}
/*
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
        format(str,sizeof(str), "**{8a6cd1}[DISCORD] {aa1bb5}%s: {ffffff}%s**",user_name, realMsg);
        SendClientMessageToAll(-1, str);
    }
    return 1;
}
*/
public OnPlayerText(playerid, text[])
{

    new msg[128];
    format(msg, sizeof(msg), "```%s(%d): %s```", PlayerName(playerid), playerid, text);
    DCC_SendChannelMessage(Player_Chat, msg);
    return 1;
  
}
public OnRconLoginAttempt(ip[], password[], success)
{
    new playerid;
    if(!success)
    {
        new msg[250];
        format(msg, sizeof(msg),"**[Security System]**`%s` **attempted a rcon login with password** `%s` **and failed, Ban him quickly if it's not you or your friend**", PlayerName(playerid),password);
        DCC_SendChannelMessage(Security_Channel,msg);
    }
    if(success == 1)
    {
        new msg[128];
        format(msg, sizeof(msg),"[Security System]%s successfully logged into rcon\n Use /ban <name> to ban him if it's not you", PlayerName(playerid));
        DCC_SendChannelMessage(Security_Channel,msg);
    }
    return 1;
}
public OnRconCommand(cmd[])
{

    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_BUGSUGGEST:
                    {
                        if(!response)
                        {
                            return 1;

                        }
                        if(response)
                        {

                                if(bugreport[playerid] == 1)
                                {
                                    new string[1000];
                                    bugreport[playerid] = 0;
                                    format(string, sizeof(string), "```Bug reported by  %s(%i) : %s```",PlayerName(playerid),playerid,inputtext);
                                    DCC_SendChannelMessage(BS_Channel,string);
                                    SendClientMessage(playerid, COLOR_ORANGE, "Bug reported successfully.");
                                }
                                else
                                {
                                    new string[1000];
                                    format(string, sizeof(string), "```New suggestion by  %s(%i) : %s```",PlayerName(playerid),playerid,inputtext);
                                    DCC_SendChannelMessage(BS_Channel,string);
                                    SendClientMessage(playerid, COLOR_ORANGE, "Suggestion posted successfully.");
                                }

                                

                        }
                    }
    }
    return 1;
}

/////////////////////////////COMMANDS//////////////////////COMMANDS///////////////////////////////////////////COMMANDS///////////////////////////////COMMANDS/////////
public OnDiscordCommandPerformed(DCC_User:user, DCC_Channel:channel, cmdtext[], success)
{
/*
    if(channel != Server_Connect || Player_Connect || Player_Disconnect || Command_Logs || Player_Chat || Admin_Channel || Security_Channel )
    {
        DCC_SendChannelMessage(channel, "[ERROR] You can use B-Discord commands only in B-Discord affected channels" );
    }
*/
    if(!success) {
    
        DCC_SendChannelMessage(channel, "[ERROR] **This command does not exist!**");
    }

    return 1;
}
BCMD:info(user, channel, params[]) 
{
        new str[2048], footer[1024];
        format(str, sizeof(str), "Server Information.");
        new DCC_Embed:embed = DCC_CreateEmbed(str, "IP - Coming SOON\nGamemode - YOUR GAMEMODE \nServer Slot - SERVESLOT \nLanguage - SERVERLANGUAGE \nForums - FORUMS ");
        DCC_SetEmbedColor(embed, 0xFF0000);
        format(footer, sizeof(footer), "Note: ADD YOUR NOTE HERE.");
        DCC_SetEmbedFooter(embed, footer);
        return DCC_SendChannelEmbedMessage(channel, embed);
    
}
BCMD:cmds(user, channel, params[]) 
{
        new str[2048], footer[1024];
        format(str, sizeof(str), "Player Commands");
        new DCC_Embed:embed = DCC_CreateEmbed(str, "!info \n!players \n!say{text} \n!credits \n !admins \n!helpers \n !testers \n !quotes ");
        DCC_SetEmbedColor(embed, 0xFF0000);
        format(footer, sizeof(footer), "Note: Different level required for different command use.");
        DCC_SetEmbedFooter(embed, footer);
        return DCC_SendChannelEmbedMessage(channel, embed);
   
}

public DiscordSendLog(playerid,command[])
{
  new loggertext[128];
  format(loggertext,sizeof(loggertext),"```%s(%i) Used %s command.```",PlayerName(playerid),playerid,command);
  return DCC_SendChannelMessage(Command_Logs, loggertext);
}
public DiscordSendLogTarget(playerid,command[],target)
{
  new loggertext[128];
  format(loggertext,sizeof(loggertext),"```%s(%i) Used %s command on %s(%i).```",PlayerName(playerid),playerid,command,PlayerName(target),target);
  DCC_SendChannelMessage(Command_Logs, loggertext);
}
BCMD:acmds(user, channel, params[]) 
{
    if (channel == Admin_Channel) 
    {
        new str[2048], footer[1024];
        format(str, sizeof(str), "Discord Admin Commands.");
        new DCC_Embed:embed = DCC_CreateEmbed(str, "\n!getstats [id]\n!aclear \n!aslap[id]\n!kick[id] \n!freeze[id] \n!unfreeze[id] \n!ban[id] \n!restart  \n !time \n!giveallcash [amount]\n!giveallscore\n!healall \n!armourall\n!explode [id] " );
        format(footer, sizeof(footer), "Note: Different level required for different command use.");
        DCC_SetEmbedFooter(embed, footer);
        return DCC_SendChannelEmbedMessage(channel, embed);
    }

    else DCC_SendChannelMessage(channel, "[ERROR] You don't have an appropriate role to use this command." );
    
    return 1;
}


BCMD:players(user, channel, params[]) 
{
        new iPlayers = Iter_Count(Player);
        new count = 0;
        new szBigString[1000];
        szBigString[ 0 ] = '\0';
        if ( iPlayers <= 30 )
        {
        foreach(new i : Player) {
            if ( IsPlayerConnected( i ) ) {
                format( szBigString, sizeof( szBigString ), "%s%s (ID: %d)\n", szBigString, PlayerName( i ), i );
                count++;
            }
        }
        }
        format( szBigString, sizeof( szBigString ), "%sThere are %d player(s) online.", szBigString, count );
        DCC_SendChannelMessage(channel,szBigString);
        //DCC_TriggerBotTypingIndicator(channel);
        return 1;
}
BCMD:say(user, channel, params[]) {

        if(isnull(params)) return DCC_SendChannelMessage(channel, "**Usage: !say [msg]**");
        if(channel == Player_Chat)
        {
            new str[144], str1[144],username[33];
            DCC_GetUserName(user, username, sizeof(username));
            format(str, sizeof(str), "{8a6cd1}[DISCORD] {aa1bb5}%s: {ffffff}%s", username, params);
            SendClientMessageToAll(-1, str);
            format(str1, sizeof(str1), "```%s```",params);
            DCC_SendChannelMessage(channel, str1);
            return 1;
        }
        else return DCC_SendChannelMessage(channel, "[ERROR] You can  use this command only in player-chat channel !");
}

//DISCORD ADMINS 
SendClientMessage2(playerid, color, message[])
{
  if (strlen(message) <= MAX_CLIENT_MSG_LENGTH) {
    SendClientMessage(playerid, color, message);
  }
  else {
    new string[MAX_CLIENT_MSG_LENGTH + 1];
    strmid(string, message, 0, MAX_CLIENT_MSG_LENGTH);
    SendClientMessage(playerid, color, string);
  }
  return 1;
}

BCMD:freeze(user, channel, params[])
{
    if (channel != Admin_Channel) 
    {
      DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
      return 1;
    }
    new playerid;
    if(sscanf(params, "u", playerid))
        {
                    DCC_SendChannelMessage(Admin_Channel, "**Usage: !FREEZE [ID]**");
        }
    {
        if(IsPlayerConnected(playerid))
        {
            new msg[128];
            format(msg, sizeof(msg), "**[FREEZE] You have frozzed** ``%s.``", PlayerName(playerid));
            DCC_SendChannelMessage(Admin_Channel, msg);
            format(msg, sizeof(msg), "{FF0000}You {00CCCC}had been frozen by {247A46}Discord Administrator.");
            SendClientMessage2(playerid, 0xFF0000C8, msg);
            TogglePlayerControllable(playerid, 0);
        }
    }
    return 1;
}
BCMD:unfreeze(user, channel, params[])
{
    new playerid;
    if (channel != Admin_Channel) 
    {
      DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
      return 1;
    }
    if(sscanf(params, "u", playerid))
        {
                    DCC_SendChannelMessage(Admin_Channel, "**[USAGE]: !UNFREEZE [ID]**");
                    return 1;
        }
    {

        if(IsPlayerConnected(playerid))
        {
            new msg[128];
            format(msg, sizeof(msg), "```[UNFREEZE]You  unfrozed  %s.```", PlayerName(playerid));
            DCC_SendChannelMessage(Admin_Channel, msg);
            format(msg, sizeof(msg), "{FF0000}You {00CCCC}had been unfrozen by {247A46}Discord Administrator.");
            SendClientMessage2(playerid, 0xFF0000C8, msg);
            TogglePlayerControllable(playerid, 1);
        }
    }
    return 1;
}
BCMD:kick(user, channel, params[])
{
    if (channel != Admin_Channel) 
        {
          DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
          return 1;
        }
    new targetid;
    if(IsPlayerConnected(targetid))
    {
        new string[125],string2[125];
        if(sscanf(params,"u",targetid)) return DCC_SendChannelMessage(channel,"**[USAGE]:/kick [playerid]**");
        if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid)) return DCC_SendChannelMessage(channel," [ERROR] : The id you have typed is invalid!");
        format(string, sizeof(string), "SERVER:{FF0000} %s {00CCCC}has been kicked from the server by {247A46}Discord Administrator.", PlayerName(targetid));
        SendClientMessageToAll(COLOR_RED, string);
        format(string2, sizeof(string2), "```SERVER: You kicked %s.```", PlayerName(targetid));
        DCC_SendChannelMessage(Admin_Channel, string2);
        Kick(targetid);
        return 1;
    }
    else return DCC_SendChannelMessage(Admin_Channel, "Id not found");

}
BCMD:aslap(user, channel, params[])
{
    new id, str2[128], Float:x, Float:y, Float:z;
    if (channel == Admin_Channel) 
    {
      if(sscanf(params, "u", id)) return DCC_SendChannelMessage(Admin_Channel, "**Usage: !aslap [ID]**");
      if(id == INVALID_PLAYER_ID || !IsPlayerConnected(id)) return  DCC_SendChannelMessage(channel," [ERROR] : The id you have typed is invalid!");
      format(str2, sizeof(str2), "{FF0000}You {00CCCC} have been Slapped By {247A46}Discord Administrator.");
      SendClientMessageToAll(0x0000FFFF, str2);
      format(str2, sizeof(str2), "**[SLAP] You have slapped %s.**", PlayerName(id));
      DCC_SendChannelMessage(Admin_Channel, str2);
      GetPlayerPos(id, x, y, z);
      SetPlayerPos(id, x, y, z+10);
      return 1;
    }
    else return DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
}
BCMD:aclear(user, channel, message[])
{
  if (channel != Admin_Channel) 
    {
      DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
      return 1;
    }
  {
  for( new i = 0; i <= 100; i ++ ) SendClientMessageToAll(COLOR_WHITE, "" );
  }
  new string[256];
  format(string, sizeof(string), "{247A46}* Discord Administrator {FFFFFF}has cleared the chat.");
  SendClientMessageToAll(COLOR_WHITE, string);
  format(string, sizeof(string), "**[CHAT] You have cleared the chat.**");
  DCC_SendChannelMessage(Admin_Channel, string);
  #pragma unused message
  return 1;
}
BCMD:getstats(user, channel, params[])
{
        if (channel != Admin_Channel) 
        {
            DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
            return 1;
        }
        new targetid;
        if(IsPlayerConnected(targetid))
        {

                new msg[600],  pIP[128], Float:health, Float:armour;
                if(sscanf(params, "u",  targetid)) return DCC_SendChannelMessage(Admin_Channel, "**Usage: !getstats [ID]**");
                if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid)) return DCC_SendChannelMessage(channel," [ERROR] : The id you have typed is invalid!");
                GetPlayerIp(targetid, pIP, 128);
                GetPlayerHealth(targetid, health);
                GetPlayerArmour(targetid, armour);
                new ping;
                ping = GetPlayerPing(targetid);
                format(msg, sizeof(msg), "``%s``'s info: **PLAYER-IP**: ``%s`` | **PLAYER-Health**: ``%d`` | **PLAYER-Armour**: ``%d`` | **PLAYER-Ping**: ``%i``", PlayerName(targetid), pIP, floatround(health), floatround(armour), ping);
                DCC_SendChannelMessage(Admin_Channel, msg);
                return 1;
        }
        else return  DCC_SendChannelMessage(channel, "[ERROR] Player is not connected !");
}
BCMD:announce(user, channel, params[])
{
  if (channel == Admin_Channel) 
    {
        new string[128]; //Making new text.
        if(isnull(params)) return DCC_SendChannelMessage(Admin_Channel, "**USAGE: /announce [text]**"); //If you only type /announce this will happen.
        format(string,sizeof(string),"{247A46}*Discord Announcement: {00CCCC}%s",params);
        SendClientMessageToAll(COLOR_WHITE,string);
        DCC_SendChannelMessage(channel,":loudspeaker: **Announcement has been  successfully sended to the server**");
        return 1;
    }
  else return DCC_SendChannelMessage(channel, ":no_entry_sign: :no_entry_sign: **[ERROR] You can  use this command only in Admin channels**!");
}
BCMD:ban(user, channel , params[])
{
    new msg[128],msg2[128],targetid;
    if(channel == Admin_Channel|| Security_Channel)
    {
        if(IsPlayerConnected(targetid))
        {
            if(sscanf(params, "u", targetid)) return DCC_SendChannelMessage(Admin_Channel, "**Usage: !ban [ID]**");
            format(msg, sizeof(msg),"{247A46}Discord Administrator has banned {00CCCC}%s.", PlayerName(targetid));
            SendClientMessageToAll(COLOR_RED,msg);
            format(msg2, sizeof(msg2),"```[Discord Security] You have banned %s.```", PlayerName(targetid));
            DCC_SendChannelMessage(channel,msg2);
            Ban(targetid);
            return 1;
        }
        return 1;
        
    }
    else return DCC_SendChannelMessage(channel,":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
}
BCMD:credits(user, channel, params[]) 
{
        DCC_SendChannelMessage(channel, "> **B-Discord System**\n> **Created/Scripted by - Bo$$** \n> **Beta Testers - Mahian Mahmud(CxB) , Link (Ultra-h Staff) , Protector ** \n> **Speical thanks to --> Ultra-h ,Sa-Mp team & Protector** \n> **You can directly dm me via discord - Bo$$#5950**\n> **In-Case you want to report a bug then -** https://github.com/BOSS294/Boss-Discord-System\n>" );
        return 1;
}
BCMD:restart(user, channel , params[])
{
    if(channel == Admin_Channel || Security_Channel)
    {
        SendClientMessageToAll(COLOR_RED,"{00CCCC}Server Has been Restarted by {247A46}Discord Administrator");
        DCC_SendChannelMessage(Admin_Channel,"**Server is now restarting...**");
        SendRconCommand("gmx");
        return 1;
    }
    else return DCC_SendChannelMessage(channel,":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
}
BCMD:time(user, channel , params[])
{
        if (channel != Admin_Channel) 
        {
            DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
            return 1;
        }
        new string[125];
        new hour,minuite,second;
        gettime(hour,minuite,second);
        format(string, sizeof(string), "In-Game time `%d:%d:%d`", hour, minuite, second);
        DCC_SendChannelMessage(Admin_Channel,string);
        return 1;
}

BCMD:giveallcash(user, channel , params[])
{
  for(new i = 0; i < MAX_PLAYERS; i ++)
  {
        if (channel != Admin_Channel) 
        {
            DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
            return 1;
        }
        new ammount;
        if(sscanf(params,"d", ammount)) return  DCC_SendChannelMessage(Admin_Channel,"**[USAGE]: !giveallcash [amount]**");
        if(IsPlayerConnected(i))
        {
                GivePlayerMoney(i, ammount);
                new str[150],string[256];
                format(str, sizeof(str),"{247A46}Discord Administrator {00CCCC}has given everyone $%d money",ammount);
                SendClientMessageToAll(COLOR_ORANGE, str);
                format(string, sizeof(string), "**Successfully given all the players $%d amount of cash**",ammount);
                DCC_SendChannelMessage(Admin_Channel,string);
         }
  }
  return 1;
}
BCMD:giveallscore(user, channel , params[])
{
  for(new i = 0; i < MAX_PLAYERS; i ++)
  {
        if (channel != Admin_Channel) 
        {
            DCC_SendChannelMessage(channel, "**:no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!****");
            return 1;
        }
        new ammount;
        if(sscanf(params,"d", ammount)) return  DCC_SendChannelMessage(Admin_Channel,"**[USAGE]: /giveallscore [ammount]**");
        if(IsPlayerConnected(i))
        {
                SetPlayerScore(i, GetPlayerScore(i)+ammount);
                new str[150],string[256];
                format(str, sizeof(str),"{247A46}Discord Administrator {00CCCC}has given everyone %d score(s)",ammount);
                SendClientMessageToAll(COLOR_ORANGE, str);
                format(string, sizeof(string), "Successfully given all the players %d score",ammount);
                DCC_SendChannelMessage(Admin_Channel,string);
         }
  }
  return 1;
}

BCMD:healall(user, channel , params[])
{
        if (channel != Admin_Channel) 
        {
            DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
            return 1;
        }
        for(new i =0; i < MAX_PLAYERS; i ++ )
           {
                 if(IsPlayerConnected(i))
                 {
                   SetPlayerHealth(i, 100.0);
                   SendClientMessageToAll(COLOR_ORANGE, "{247A46}Discord Administrator {00CCCC}has healed all players!");
                   DCC_SendChannelMessage(Admin_Channel,"Successfully healed all the players ");
                 }
           }
        return 1;
}
BCMD:armourall(user, channel , params[])
{
        if (channel != Admin_Channel) 
        {
            DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
            return 1;
        }
        for(new i =0; i < MAX_PLAYERS; i ++ )
           {
                 if(IsPlayerConnected(i))
                 {
                   SetPlayerArmour(i, 100.0);
                   SendClientMessageToAll(COLOR_ORANGE, "{247A46}Discord Administrator {00CCCC}has armoured all players!");
                   DCC_SendChannelMessage(Admin_Channel,"Successfully armoured all the players ");
                 }
           }
        return 1;
}
BCMD:explode(user, channel , params[])
{
          if (channel != Admin_Channel) 
          {
                DCC_SendChannelMessage(channel, ":no_entry_sign: **[ERROR] You can use this command only in Admin or Security Channel!**");
                return 1;
          }
          new player1, Float:x, Float:y, Float:z, str[70];
          if(sscanf(params,"d", player1)) return DCC_SendChannelMessage(Admin_Channel,"**[USAGE]: /explode [playerid]**");
          if(IsPlayerConnected(player1))
          {
                 GetPlayerPos(player1, x, y, z);
                 CreateExplosion(x, y, z, 7, 10.0);
                 format(str, sizeof(str),"```You have exploded %s!```", PlayerName(player1));
                 DCC_SendChannelMessage(Admin_Channel,str);
                 SendClientMessage(player1,COLOR_RED, "{247A46}Discord Administrator {00CCCC}has used explosions on you");
          }
                 else return DCC_SendChannelMessage(Admin_Channel,"That player is not connected!");
          return 1;
}
BCMD:quote(user, channel, params[])
{ 
        new random_index = random(MAX_QUOTES - 1); // Generate a random index number for the quotes array
        DCC_SendChannelMessage(channel, quotes[random_index]);
        return 1;

}

//INGAME COMMANDS
CMD:bug(playerid,params[])
{
    bugreport[playerid] = 1;
    ShowPlayerDialog(playerid, DIALOG_BUGSUGGEST, DIALOG_STYLE_INPUT, "Enter the bug", "Type the bug below", "Ok", "Cancel");
    return 1 ;
}
CMD:suggestion(playerid,params[])
{
    ShowPlayerDialog(playerid, DIALOG_BUGSUGGEST, DIALOG_STYLE_INPUT, "Enter the suggestion", "Type the suggestion below", "Ok", "Cancel");
    return 1;
}
CMD:savecord(playerid,params[])
{
    //x,y,z,facingangle,interior,virtualid
    new Float:posx,Float:posy,Float:posz,Float:ang,inter,vWrld,string[128];
    GetPlayerPos(playerid, posx, posy, posz);
    GetPlayerFacingAngle(playerid, ang);
    inter = GetPlayerInterior(playerid);
    vWrld = GetPlayerVirtualWorld(playerid);
    format(string, sizeof(string),"```Saved position -> %f,%f,%f,%f,%i,%i```",posx,posy,posz,ang,inter,vWrld);
    DCC_SendChannelMessage(Cord_Channel,string);
    SendClientMessage(playerid,COLOR_ORANGE,"Cords saved succesfully");
    return 1;
}
