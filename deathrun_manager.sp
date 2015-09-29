#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#undef REQUIRE_EXTENSIONS
#include <cstrike>
#include <colors>
#define REQUIRE_EXTENSIONS

#define MESSAGE "[{green}Deathrun{default}] %t"
#define TEAM_T 2
#define TEAM_CT 3
#define PLUGIN_VERSION "1.0"

new Handle:drmg_version = INVALID_HANDLE;
new Handle:drmg_enabled = INVALID_HANDLE;
new Handle:drmg_ratio = INVALID_HANDLE;

public Plugin:myinfo =
{
  name = "Deathrun Manager",
  author = "brownzilla",
  description = "Controls the players on the servers",
  version = PLUGIN_VERSION,
  url = "http://sourcemod.net"
};

public OnPluginStart() {
  LoadTranslations("deathrun_manager.phrases");

  HookEvent("round_start", Event_RoundStart);

  drmg_version = CreateConVar("drmg_version", PLUGIN_VERSION, "The current version of the manager", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
  drmg_enabled = CreateConVar("drmg_enabled", "1", "Enable or Disable the Manager: 0 = Disabled | 1 = Enabled.");
  drmg_ratio = CreateConVar("drmg_ratio", "5", "Change the Ratio of Deaths to Runners (Default 1 Death = 5 Runners).");

  SetConVarString(drmg_version, PLUGIN_VERSION);
  AutoExecConfig( true, "deathrun_manager" );

  RegConsoleCmd( "jointeam", death2runners );
}

public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast) {
    if (GetConVarInt(drmg_enabled) == 1) {
      CPrintToChatAll(MESSAGE, "enabled");
    } else if (GetConVarInt(drmg_enabled) == 0) {
      CPrintToChatAll(MESSAGE, "disabled");
    }
    CPrintToChatAll(MESSAGE, "credit");
}
public Action:death2runners(client, args) {
  new teamRatio = GetConVarInt(FindConVar("drmg_ratio"));

  decl String:teamString[3];
	GetCmdArg( 1, teamString, sizeof(teamString));

	new newTeam = StringToInt(teamString);
	new oldTeam = GetClientTeam(client);

  if (newTeam == TEAM_T && oldTeam != TEAM_T) {
    new id = 0;
    new countTs = 0;
    new countCTs = 0;
    for(id=1; id <= MaxClients; id++) {
      if(IsClientInGame(id)){
        if(GetClientTeam(id) == TEAM_T)  {
          countTs++;
        }
        if(GetClientTeam(id) == TEAM_CT){
          countCTs++;
        }
      }
    }
    if ( countTs < ( ( countCTs ) / teamRatio ) || ! countTs ) {
      return Plugin_Continue;
    } else {
      ClientCommand(client, "play ui/freeze_cam.wav");
      CPrintToChat(client, MESSAGE, "transfer fail");
      return Plugin_Handled;
    }
  }
  return Plugin_Continue;
}
