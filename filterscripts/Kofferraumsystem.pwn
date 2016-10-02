// Alle wichtigen Packages importieren
#include <a_samp>
#include <ocmd>
#include <sscanf2>

// Farbendefinierung
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_SEAGREEN 0x20B2AAAA
#define COLOR_LIMEGREEN 0x32CD32AA
#define COLOR_MIDNIGHTBLUE 0X191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define COLOR_ORANGERED 0xFF4500AA
#define COLOR_PINK 0xFFC0CBAA
#define COLOR_SPRINGGREEN 0x00FF7FAA
#define COLOR_TOMATO 0xFF6347AA
#define COLOR_YELLOWGREEN 0x9ACD32AA
#define COLOR_MEDIUMAQUA 0x83BFBFAA
#define COLOR_MEDIUMMAGENTA 0x8B008BAA
#define COLOR_MIDBLUE 0x0055FFFF

#define DIALOG_BOOT 1
#define DIALOG_BOOT_INV 2


// Labeldefinierung
new engine, lights, alarm, doors, bonnet, boot, objective, bool:boottest[MAX_PLAYERS], vehid;


// Befehle

ocmd:boot(playerid, params[])
{
	if(sscanf(params, "i", vehid)) return SCM(playerid, COLOR_GREY, "Verwendung: /boot [CAR-ID]");
 	if(!boottest[playerid])
 	{
 	GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);
 	SetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
 	SCM(playerid, COLOR_GREY, "Kofferraum geöffnet");
	boottest[playerid] = true;
 	} else if(boottest[playerid])
 	{
 	GetVehicleParamsEx(vehid, engine, lights, alarm, doors ,bonnet, boot, objective);
 	SetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
 	SCM(playerid, COLOR_GREY, "Kofferraum geschlossen");
    boottest[playerid] = false;
    }
    return 1;
}

ocmd:bootinv(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_BOOT, DIALOG_STYLE_LIST, "Kofferraum", "Beladen\nEntladen\nInhalt", "Auswahl", "Abbrechen");
	return 1;
}

// Callback-Funktionen
public OnFilterScriptInit() {
	print("\n\n========================================");
	print("=======  RPG-City Quest System  ========");
	print("========================================\n\n");
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_BOOT)
	{
		if(response)
		{
		    switch(listitem)
		    {
		        case 0: ShowPlayerDialog(playerid, DIALOG_BOOT_INV, DIALOG_STYLE_LIST, "Kofferraum - Beladen", "Drogen\nMats\nKanister\nPaket\nWaffen", "Auswahl", "Abbrechen");
		        case 1: ShowPlayerDialog(playerid, DIALOG_BOOT_INV, DIALOG_STYLE_LIST, "Kofferraum - Entladen", "Drogen\nMats\nKanister\nPaket\nWaffen", "Auswahl", "Abbrechen");
		        case 2: ShowPlayerDialog(playerid, DIALOG_BOOT_INV, DIALOG_STYLE_LIST, "Kofferraum - Inhalt", "Drogen\nMats\nKanister\nPaket\nWaffen", "Auswahl", "Abbrechen");
			}
		} else {
		SCM(playerid, COLOR_RED, "Abgebrochen.");
		return 1;
		}
	}
	return 0;
}

public OnFilterScriptExit() {
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid) {
	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	return 1;
}

public OnPlayerSpawn(playerid) {
    SetPlayerPos(playerid, 1536.251831, -1545.219726, 67.210937);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {
	return 1;
}

public OnVehicleSpawn(vehicleid) {
	return 1;
}

public OnVehicleDeath(vehicleid, killerid) {
	return 1;
}

public OnPlayerText(playerid, text[]) {
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid) {
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid) {
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid) {
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid) {
	return 1;
}

public OnRconCommand(cmd[]) {
	return 1;
}

public OnPlayerRequestSpawn(playerid) {
	return 1;
}

public OnObjectMoved(objectid) {
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid) {
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid) {
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid) {
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) {
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row) {
	return 1;
}

public OnPlayerExitedMenu(playerid) {
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success) {
	return 1;
}

public OnPlayerUpdate(playerid) {
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid) {
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid) {
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid) {
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid) {
	return 1;
}



public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	return 1;
}

SCM(playerid, color, text[])
{
	return SendClientMessage(playerid, color, text);
}







/*




ocmd:createlabel(playerid)
{
	new Float:playerX, Float:playerY, Float:playerZ;
	GetPlayerPos(playerid, playerX, playerY, playerZ);
	TestLabel = Create3DTextLabel("Hier war jemand doof und hat\nmich erstellt, lel.", 0xFF8C00FF, playerX, playerY, playerZ, 50, 0);
	SendClientMessage(playerid, COLOR_RED, "Label erstellt");
	return 1;
}

ocmd:deletelabel(playerid)
{
	Delete3DTextLabel(TestLabel);
	SendClientMessage(playerid, COLOR_RED, "Label zerstört");
	return 1;
}

ocmd:tv(playerid, params[])
{
    new spec, message[128];
	if(sscanf(params, "%i", spec)){
	TogglePlayerSpectating(playerid, 0);
	SendClientMessage(playerid, COLOR_RED, "Du beobachtest niemand mehr");
	} else {
	TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, spec);
	format(message, sizeof(message), "Du beobachtest nun ID %i", spec);
	SendClientMessage(playerid, COLOR_GREY, message);
	}
	return 1;
}

ocmd:createacar(playerid)
{
	CreateVehicle(411, 1493.790649, -1545.125366, 67.207191, 0, -1, -1, -1);
	CreateVehicle(411, 1512.525878, -1543.352416, 67.210937, 0, -1, -1, -1);
	return 1;
}
*/
