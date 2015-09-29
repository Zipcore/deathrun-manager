#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#undef REQUIRE_EXTENSIONS
#include <cstrike>
#define REQUIRE_EXTENSIONS

#define MESSAGE "[Deathrun] %t"
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
  url = "https://sourcemod.net"
};

public OnPluginStart() {
  LoadTranslations("deathrun_manager.phrases");

  HookEvent("player_death", Event_PlayerDeath);
  HookEvent("round_end", Event_RoundEnd);
  HookEvent("player_hurt", Event_PlayerHurt);

  drmg_version = CreateConVar("drmg_version", PLUGIN_VERSION, "The current version of the manager", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
  drmg_enabled = CreateConVar("drmg_enabled", "1", "Enable or Disable the Manager: 0 = Disabled | 1 = Enabled.");
}
