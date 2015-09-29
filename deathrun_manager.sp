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
}
