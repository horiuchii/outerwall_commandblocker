#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

bool g_bOuterWallCommandBlockerEnabled = false;

public Plugin myinfo =
{
	name = "Outer Wall Coin Transmit",
	author = "Horiuchi",
	description = "A companion plugin for pf_outerwall that replaces the bonus 6 coin radar with coins that disappear per player",
	version = "1.0",
};

public void OnPluginStart()
{
	char mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	CheckIfPluginShouldBeActive(mapName);

	AddCommandListener(MarkPlayerAsCheated, "sm_timer");
	AddCommandListener(MarkPlayerAsCheated, "sm_boost");
	AddCommandListener(MarkPlayerAsCheated, "pf_boost");
	AddCommandListener(MarkPlayerAsCheated, "sm_heal");
	AddCommandListener(MarkPlayerAsCheated, "sm_tele");
	AddCommandListener(MarkPlayerAsCheated, "sm_tl");
	AddCommandListener(MarkPlayerAsCheated, "sm_fly");
	AddCommandListener(MarkPlayerAsCheated, "sm_goto");

	PrintToServer("Loaded outerwall_commandblocker...");
}

public void OnMapInit(const char[] mapName)
{
	CheckIfPluginShouldBeActive(mapName);
}

void CheckIfPluginShouldBeActive(const char[] mapName)
{
	g_bOuterWallCommandBlockerEnabled = StrContains(mapName, "pf_outerwall") != -1 ? true : false;
}

public Action MarkPlayerAsCheated(int iClient, const char[] command, int argc)
{
	if(!g_bOuterWallCommandBlockerEnabled)
		return Plugin_Continue;

	char ScriptCommand[64];
	Format(ScriptCommand, sizeof(ScriptCommand), "script PlayerCheatedCurrentRun[%i] = true", iClient);
	ServerCommand(ScriptCommand);

	return Plugin_Continue;
}