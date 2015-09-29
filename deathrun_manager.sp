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

  HookEvent("player_death", Event_PlayerDeath);
  //HookEvent("round_end", Event_RoundEnd);
  HookEvent("round_start", Event_RoundStart);

  drmg_version = CreateConVar("drmg_version", PLUGIN_VERSION, "The current version of the manager", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
  drmg_enabled = CreateConVar("drmg_enabled", "1", "Enable or Disable the Manager: 0 = Disabled | 1 = Enabled.");

  SetConVarString(drmg_version, PLUGIN_VERSION);
  AutoExecConfig(true, "deathrun_manager");
}

public OnConfigsExecuted() {
  decl String:mapname[128];
  GetCurrentMap(mapname, sizeof(mapname));
  if(strncmp(mapname, "dr_", 3, false) == 0 || (strncmp(mapname, "deathrun_", 9, false) == 0)) {
    LogMessage("Deathrun map detected. Enabling Deathrun Manager.");
    SetConVarInt(drmg_enabled, 1);
  } else {
    LogMessage("Disabling Deathrun Manager.");
    SetConVarInt(drmg_enabled, 0);
  }
}

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast) {
  CPrintToChatAll(MESSAGE, "player death");
}

public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast) {
    if (GetConVarInt(drmg_enabled) == 1) {
      CPrintToChatAll(MESSAGE, "enabled");
    } else {
      CPrintToChatAll(MESSAGE, "disabled");
    }
}
