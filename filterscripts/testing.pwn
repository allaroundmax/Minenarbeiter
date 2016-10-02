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

#define DIALOG_WEAPON 1
#define DIALOG_HELP 2
#define DIALOG_QUEST 3
#define MAX_QUESTS 6

// Labeldefinierung
//new Text3D:TestLabel;
//new Text:missiontext[MAX_PLAYERS];
new bool:mis1Check1[MAX_PLAYERS], bool:mis1Check2[MAX_PLAYERS], bool:mis1Check3[MAX_PLAYERS], bool:mis1Check4[MAX_PLAYERS];
new bool:mis2Check1[MAX_PLAYERS]; //, mis2Check2[MAX_PLAYERS], mis2Check3[MAX_PLAYERS], mis2Check4[MAX_PLAYERS];

// Enumdefinierung
enum playerInfo
{
	currentQuestgeber,
	currentQuest
};

enum questActor
{
	actorSkin,
	name[MAX_PLAYER_NAME],
	befehlName[MAX_PLAYER_NAME],
	Float:actorX,
	Float:actorY,
	Float:actorZ,
	Float:actorAng,
};

enum questEnum
{
	owner[30],
	heading[128],
	beschreibung[2048]
};

// Player Arrays
//new pInfo[][playerInfo];

// QuestActor Arrays
new qActor[][questActor] = {
	{161, "Rudolf", "Rudolf", -53.227, 1.569, 3.117, 124.995},
	{28, "Carl", "Carl", 1341.597412, -629.019287, 109.134902, 5.0},
	{16, "Can", "Can", 2743.146484, -2453.818603, 13.862256, 270.0},
	{16, "Gustavo", "Gustavo", -1344.294921, 440.925384, 7.187500, 180.0}
};
new qActorID[MAX_ACTORS];
new Text3D:qActorTextID[MAX_ACTORS];

// Quest Array
new quest[][questEnum] = {
	{"Rudolf", "{FFFF00}Quest #1: {FFFFFF}Neue, erntereiche Samensorte\n", "Hey, Mr. Chamberlain hat Samen für Weizen genetisch verändert.\nDiese sollen 3x mehr Ertrag bringen!\nLeider ist mein Tampa kaputt gegangen und er hat nur\nbegrenzt Samen auf Lager. Und diese werden schnell verkauft sein.\n\nKönntest du mir schnell welche kaufen?\nIch zahle dir das doppelte vom Kaufpreis zurück!"},
	{"Rudolf", "{FFFF00}Quest #2: {FFFFFF}Rätselvolle Ernte\n", "Hey, ich habe eine sehr rätselvolle Ernte dieses Jahr eingefahren!\nIch bitte dich darum, diese zu Mr. Lewis zu bringen,\ndamit der diese für mich untersuchen kann!\nIch werde dir eine gute Belohnung ausstellen, wenn du dies überbringst!"},
 	{"Carl", "{FFFF00}Quest #1: {FFFFFF}Materiallieferung\n", "Hey Du!\n\nIch erwarte eine Lieferung mit Waffen.\nKannst Du diese Lieferung abholen?\n\nDie Lieferung kommt am Hafen von Los Santos an\n\nCan erwartet Dich bereits, rede mit ihm.\nDu wirst auch entlohnt!"},
	{"Carl", "{FFFF00}Quest #2: {FFFFFF}Drogenlieferung\n", "Hey Du!\n\nIch erwarte eine Lieferung mit Drogen.\nKannst Du diese Lieferung abholen?\n\nDie Lieferung kommt am Hafen von San Fierro an\n\nGustavo erwartet Dich bereits, rede mit ihm.\nDu wirst auch entlohnt!"},
    {"Can", "{FFFF00}Matsquest: {FFFFFF}Materiallieferung\n", "Da bist Du ja endlich!\nBeeil dich, mein Boss ist bald von der Mittagspause zurück.\nDas Paket steht in der Lagerhalle zwei auf der linken Seite im Regal."},
    {"Gustavo", "{FFFF00}Drogenquest: {FFFFFF}Drogenlieferung\n", "Da bist Du ja!\nDie Drogen sind noch auf dem Schiff, unten drin.\nDu musst dich aber beeilen, mein Boss ist in 5 Minuten da."}
};


// Timerdefinierung
//forward missionending(playerid);

// Befehle
ocmd:questtalk(playerid, params[])
{
	new actorID, actorName[30], msg[128], msgtest[128];
	if(sscanf(params, "s[30]", actorName)) return SCM(playerid, COLOR_GREY, "Verwendung: /questtalk [Name des Questgebers]");
	actorID = GetActorIDByName(actorName);
	format(msgtest, sizeof(msgtest), "%i", actorID);
	SCM(playerid, COLOR_RED, msgtest);
	if(actorID == -1)
	{
	    format(msg, sizeof(msg), "%s ist kein Questgeber!", actorName);
	    SCM(playerid, COLOR_GREY, msg);
	    return 1;
	} else {
	    if(!IsPlayerInRangeOfPoint(playerid, 3, qActor[actorID][actorX], qActor[actorID][actorY], qActor[actorID][actorZ])) return SCM(playerid, COLOR_GREY, "Du bist zu weit entfernt, um mit dem Questgeber zu reden!");

		new questHeading[128], questList[2048];  //, questName[128];
		for(new i = 0; i < MAX_QUESTS; i++)
		{
		    if(!strcmp(quest[i][owner], actorName))
		    {
		        strcat(questList, quest[i][heading], sizeof(questList));
		    }
		}

		format(questHeading, sizeof(questHeading), "{FFFF00}Questübersicht: {FFFFFF}%s", actorName);
	    ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_LIST, questHeading, questList, "Akzeptieren", "Schließen");
	}
	return 1;
}

ocmd:car(playerid, params[])
{
	new vID, Float:playerX, Float:playerY, Float:playerZ, message[128];
	if(sscanf(params, "%i", vID)) return SendClientMessage(playerid, COLOR_GREY, "Verwendung: /car [Model-ID]");
	GetPlayerPos(playerid, playerX, playerY, playerZ);
	
	CreateVehicle(vID, playerX, playerY + 5.0, playerZ, 0, -1, -1, -1);
	format(message, sizeof(message), "Du hast ein Fahrzeug mit der Model-ID %i erstellt.", vID);
	SendClientMessage(playerid, COLOR_GREY, message);
	return 1;
}

ocmd:help(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Hilfemenü", "Allgemeine Befehle", "Auswählen", "Abbrechen");
    return 1;
}


ocmd:getpos(playerid)
{
	new Float:x, Float:y, Float:z, msg[128];
	GetPlayerPos(playerid, x, y, z);
	
	format(msg, sizeof(msg), "Position: X: %f, Y: %f, Z: %f", x, y, z);
	SendClientMessage(playerid, COLOR_RED, msg);
	return 1;
}

ocmd:fixveh(playerid)
{
	new vID;
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Du bist in keinem Fahrzeug, Spast.");
	
	vID = GetPlayerVehicleID(playerid);
	RepairVehicle(vID);
	SendClientMessage(playerid, COLOR_GREY, "Dein Fahrzeug wurde repariert!");
	return 1;
}

ocmd:test(playerid)
{
	SendClientMessage(playerid, COLOR_GREY, "Hallo");
	GivePlayerMoney(playerid, 1337);
	return 1;
}

ocmd:goto(playerid, params[])
{
	new targetID, targetName[25], Float:targetX, Float:targetY, Float:targetZ, msg[128];
	
	if(sscanf(params, "i", targetID)) return SendClientMessage(playerid, COLOR_GREY, "Verwendung: /goto [ID]");
	
	GetPlayerPos(targetID, targetX, targetY, targetZ);
	SetPlayerPos(playerid, targetX + 0.5, targetY, targetZ);
	GetPlayerName(targetID, targetName, 25);
	
	format(msg, sizeof(msg), "Du hast dich zu %s teleportiert!", targetName);
	SendClientMessage(playerid, COLOR_GREY, msg);
	return 1;
}

ocmd:hafensf(playerid)
{
	SetPlayerPos(playerid, -1344.294921, 440.925384 - 1, 7.187500);
}

ocmd:setskin(playerid, params[])
{
	new pSkin, targetID, msg[128], targetmsg[128], playerName[25], targetName[25];
	if(sscanf(params, "ii", targetID, pSkin)) return SendClientMessage(playerid, COLOR_GREY, "Verwendung: /setskin [Player ID] [Skin ID]");

	SetPlayerSkin(targetID, pSkin);
	GetPlayerName(playerid, playerName, 25);
	GetPlayerName(targetID, targetName, 25);
    format(msg, sizeof(msg), "Du hast den Skin von %s zu Skin-ID %i gesetzt", targetName, pSkin);
    format(targetmsg, sizeof(targetmsg), "%s hat dir die Skin-ID %i gesetzt", playerName, pSkin);
	SendClientMessage(playerid, COLOR_MIDBLUE, msg);
	SendClientMessage(targetID, COLOR_RED, targetmsg);
	return 1;
}

ocmd:gethere(playerid, params[])
{
	new targetID, targetName[25], Float:targetX, Float:targetY, Float:targetZ, msg[128];

	if(sscanf(params, "i", targetID)) return SendClientMessage(playerid, COLOR_GREY, "Verwendung: /gethere [ID]");

	GetPlayerPos(playerid, targetX, targetY, targetZ);
	SetPlayerPos(targetID, targetX + 0.5, targetY, targetZ);
	GetPlayerName(targetID, targetName, 25);

	format(msg, sizeof(msg), "Du hast %s zu dir teleportiert!", targetName);
	SendClientMessage(playerid, COLOR_GREY, msg);
	return 1;
}

ocmd:waffen(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_WEAPON, DIALOG_STYLE_LIST, "Waffen", "Deagle\nM4\nScharfschützengewehr", "Auswählen", "Abbrechen");
	return 1;
}

ocmd:delveh(playerid, params[])
{
    new vID, message[128];
	if(sscanf(params, "%i", vID)) return SendClientMessage(playerid, COLOR_GREY, "Verwendung: /delveh [Model-ID]");

	DestroyVehicle(vID);
	format(message, sizeof(message), "Du hast ein Fahrzeug mit der Fahrzeug-ID %i zerstört.", vID);
	SendClientMessage(playerid, COLOR_GREY, message);
	return 1;
}

ocmd:spack(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 2790.827148, -2447.838134, 13.632921) && mis1Check3[playerid])
	{
	 SCM(playerid, COLOR_RED, "Ziel erreicht. Paket gefunden.");
	 SCM(playerid, COLOR_RED, "Neues Ziel. Fahre zurück zu Carl");
	 SetPlayerCheckpoint(playerid, 1341.597412, -629.019287, 109.134902, 3.0);
	 mis1Check3[playerid] = false;
	 mis1Check4[playerid] = true;
  	} else if(!IsPlayerInRangeOfPoint(playerid, 2.0, 2790.827148, -2447.838134, 13.632921) && mis1Check3[playerid])
  	{
	 SCM(playerid, COLOR_GREY, "Hier liegt es nicht. Versuch es weiter!");
 	} else if(IsPlayerInRangeOfPoint(playerid, 2.0, 2790.827148, -2447.838134, 13.632921) && !mis1Check3[playerid])
 	{
	 SCM(playerid, COLOR_RED, "Du hast die Mission nicht gestartet");
 	}
}

// Callback-Funktionen
public OnFilterScriptInit() {
	print("\n\n========================================");
	print("=======  RPG-City Quest System  ========");
	print("========================================\n\n");
    
	for(new i = 0; i < MAX_ACTORS; i++)
	{
		qActorID[i] = CreateActor(qActor[i][actorSkin], qActor[i][actorX], qActor[i][actorY], qActor[i][actorZ], qActor[i][actorAng]);

		new text[128];
		format(text, sizeof(text), "%s\n{FF4500}/questtalk %s", qActor[i][name], qActor[i][befehlName]);
		qActorTextID[i] = Create3DTextLabel(text, COLOR_LIME, qActor[i][actorX], qActor[i][actorY], qActor[i][actorZ] + 1.2, 7, 0, 1);
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
if(mis1Check2[playerid])
{
	DisablePlayerCheckpoint(playerid);
	SCM(playerid, COLOR_YELLOW, "Suche nun nach dem Paket auf der Linken Seite der Lagerhalle.");
	mis1Check2[playerid] = false;
	mis1Check3[playerid] = true;
} else if(mis1Check4[playerid])
{
	DisablePlayerCheckpoint(playerid);
	SCM(playerid, COLOR_GREY, "Carl: Danke Dir vielmals. Hier hast Du eine Bezahlung dafür.");
	SCM(playerid, COLOR_GREY, "Carl: Komm ruhig mal wieder vorbei, ich hab bald wieder ein paar Aufträge.");
	SCM(playerid, COLOR_GREEN, "Mission erfolgreich abgeschlossen. +10.000$");
	GivePlayerMoney(playerid, 10000);
	mis1Check4[playerid] = false;
}
return 1;
}
/*
public missionending(playerid)
{
	TextDrawDestroy(missiontext[playerid]);
	TextDrawUseBox(missiontext[playerid], 0);
	return 1;
}
*/

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
 	if(dialogid == DIALOG_WEAPON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: GivePlayerWeapon(playerid, WEAPON_DEAGLE, 200);
				case 1: GivePlayerWeapon(playerid, WEAPON_M4, 500);
				case 2: GivePlayerWeapon(playerid, WEAPON_SNIPER, 500);
			}
		} else {
			SendClientMessage(playerid, COLOR_RED, "Abgebrochen");
		}
		return 1;
	} else if(dialogid == DIALOG_HELP)
	{
	    if(response)
	 	{
	 	    if(listitem == 0)
	 	    {
	 	        SendClientMessage(playerid, COLOR_GREY, "/car Spawnt ein Fahrzeug    /tv Beobachtet jemand    /delveh Löscht ein Fahrzeug    /waffen Kauft Waffen");
	 	        SendClientMessage(playerid, COLOR_GREY, "/fixveh Repariert das Fahrzeug    /goto Teleportiere zu    /gethere Teleportiere zu dir    /createacar Spawne 2 Cars");
			}
		} else {
			SendClientMessage(playerid, COLOR_RED, "Abgebrochen");
		}
	} else if(dialogid == DIALOG_QUEST)
 	{
		if(response)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 4.0, -53.227, 1.569, 3.117))
		    {
		        if(listitem == 0)
		        {
		            SCM(playerid, COLOR_GREEN, "Mission gestartet");
		            SCM(playerid, COLOR_GREY, "Carl: Hey Du!");
		            SCM(playerid, COLOR_GREY, "Carl: Ich erwarte eine Lieferung mit Materialien, kannst Du die für mich Abholen?");
		            SCM(playerid, COLOR_GREY, "Carl: Die Lieferung ist im Hafen von Los Santos. Can erwartet dich bereits, also los!");
		            SCM(playerid, COLOR_RED, "Neues Ziel. Fahre zum Hafen von Los Santos und rede mit Can.");
		            SetPlayerCheckpoint(playerid, 2790.827148, -2447.838134, 13.632921, 3.0);
		            mis1Check1[playerid] = true;
          		} else if(listitem == 1){
          			SCM(playerid, COLOR_GREEN, "Mission gestartet");
		            SCM(playerid, COLOR_GREY, "Carl: Hey Du!");
		            SCM(playerid, COLOR_GREY, "Carl: Ich erwarte eine Lieferung mit Drogen, kannst Du die für mich Abholen?");
		            SCM(playerid, COLOR_GREY, "Carl: Die Lieferung ist im Hafen von San Fierro. Gustavo erwartet dich bereits, also los!");
		            SCM(playerid, COLOR_RED, "Neues Ziel. Fahre zum Hafen von San Fierro und rede mit Gustavo.");
		            SetPlayerCheckpoint(playerid, -1344.294921, 440.925384, 7.187500, 3.0);
		            mis2Check1[playerid] = true;
		   		}
		 	 } else if(IsPlayerInRangeOfPoint(playerid, 4.0, 2743.146484, -2453.818603, 13.862256))
			 {
		    	if(listitem == 0 && mis1Check1[playerid])
	    		{
                    DisablePlayerCheckpoint(playerid);
                    SCM(playerid, COLOR_RED, "Ziel erreicht.");
                    SCM(playerid, COLOR_GREY, "Can: Da bist Du ja endlich, ich hab mit dir schon früher gerechnet.");
                    SCM(playerid, COLOR_GREY, "Can: Egal, die Materialien liegen in Lagerhalle 2 in einem der Regale auf der Linken Seite.");
                    SCM(playerid, COLOR_GREY, "Can: Du hast aber nur wenig Zeit, denn mein Boss kommt gleich wieder. Also beeilung!");
                    SCM(playerid, COLOR_RED, "Neues Ziel. Gehe in Lagerhalle 2 und suche das Paket mittels /spak.");
		            mis1Check1[playerid] = false;
		            mis1Check2[playerid] = true;
		            SetPlayerCheckpoint(playerid, 2773.854003, -2455.803955, 13.637065, 3.0);
       			}
		  }
        } else {
            SCM(playerid, COLOR_RED, "Abgebrochen");
        }
  		return 1;
  	}
  	return 0;
}

public OnFilterScriptExit() {
	for(new i = 0; i < MAX_ACTORS; i++)
	{
		DestroyActor(qActorID[i]);
		Delete3DTextLabel(qActorTextID[i]);
	}
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

GetActorIDByName(actorName[])
{
	for(new i = 0; i < MAX_ACTORS; i++)
	{
	    if(strlen(qActor[i][befehlName]) == 0) continue;
	    if(!strcmp(qActor[i][befehlName], actorName, true)) return i;
	}
	return -1;
}

SCM(playerid, color, text[])
{
	return SendClientMessage(playerid, color, text);
}

// Ausgeklammert
/*
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	return 1;
}


	if(mis2onCheck1[playerid])
	{
	    SendClientMessage(playerid, COLOR_GREY, "Ziel erreicht");
	    DisablePlayerCheckpoint(playerid);
		mis2onCheck1[playerid] = false;
 	} else if(mis2onCheck2[playerid]) // if it's true
    {
 		new missiontextnew[128];
        format(missiontextnew, sizeof(missiontextnew), "Die Materialien liegen drüben im Lagerhaus in einer Kiste verpackt.\n Nimm sie mit, bevor mein Boss kommt");
        TextDrawSetString(missiontext[playerid], missiontextnew);
        TextDrawShowForPlayer(playerid, missiontext[playerid]);
        DisablePlayerCheckpoint(playerid);
       	mis2onCheck2[playerid] = false;
        SetPlayerCheckpoint(playerid, 2790.827148, -2447.838134, 13.632921, 3.0);
		mis2onCheck3[playerid] = true;
    } else if(mis2onCheck3[playerid])
    {
    new missiontextnew2[128];
    format(missiontextnew2, sizeof(missiontextnew2), "Du hast die Materialien eingepackt\nNun verschwinde bevor der Boss kommt\n\nFahre zurück zum Auftraggeber!");
    TextDrawSetString(missiontext[playerid], missiontextnew2);
    TextDrawShowForPlayer(playerid, missiontext[playerid]);
    DisablePlayerCheckpoint(playerid);
    mis2onCheck3[playerid] = false;
    SetPlayerCheckpoint(playerid, 1341.597412, -629.019287, 109.134902, 3.0);
	mis2onCheck4[playerid] = true;
    } else if(mis2onCheck4[playerid])
	{
    new missiontextnew3[128];
    DisablePlayerCheckpoint(playerid);
    format(missiontextnew3, sizeof(missiontextnew3), "Danke für das Abholen meiner Lieferung\nHier die versprochene Bezahlung!");
    TextDrawSetString(missiontext[playerid], missiontextnew3);
    TextDrawShowForPlayer(playerid, missiontext[playerid]);
    mis2onCheck4[playerid] = false;
    GivePlayerMoney(playerid, 10000);
    SendClientMessage(playerid, COLOR_MIDBLUE, "Du hast die Mission erfolgreich abgeschlossen, Glückwunsch!");
    SetTimer("missionending", 2000, false);
    }
ocmd:missioninfo(playerid, params[])
{
    new missionid;
	if(sscanf(params, "%i", missionid)) return SendClientMessage(playerid, COLOR_GREY, "Verwendung: /missioninfo [1-5]");
	if(missionid == 1)
	{
	ShowPlayerDialog(playerid, DIALOG_MISSION, DIALOG_STYLE_MSGBOX, "Mission 1", "Hey Du!\n\nIch erwarte eine Lieferung mit Drogen.\nKannst Du diese Lieferung abholen?\n\nDie Lieferung kommt am Hafen von San Fierro an\nDu wirst auch reichlich entlohnt mit 10.000$\n\nBist Du dabei?", "Schließen", "Schließen");
	}
	if(missionid == 2)
	{
	ShowPlayerDialog(playerid, DIALOG_MISSION, DIALOG_STYLE_MSGBOX, "Mission 2", "Hey Du!\n\nIch erwarte eine Lieferung mit Waffen.\nKannst Du diese Lieferung abholen?\n\nDie Lieferung kommt am Hafen von Los Santos an\nDu wirst auch reichlich entlohnt mit 10.000$\n\nBist Du dabei?", "Schließen", "Schließen");
	}
    if(missionid == 3)
	{
	ShowPlayerDialog(playerid, DIALOG_MISSION, DIALOG_STYLE_MSGBOX, "Mission 3", "Hey Du!\n\nEin Freund benötigt ein Benzinkanister\nKannst Du ihm diesen bringen?\n\nEr steht oben beim Fischerhafen an der Bayside\nDu wirst auch reichlich entlohnt mit 5.000$\n\nHilfst Du ihm?", "Schließen", "Schließen");
	}
	if(missionid == 4)
	{
	ShowPlayerDialog(playerid, DIALOG_MISSION, DIALOG_STYLE_MSGBOX, "Mission 4", "Hey Du!\n\nIch erwarte eine Lieferung mit Waffen.\nKannst Du diese Lieferung abholen?\n\nDie Lieferung kommt am Hafen von Los Santos an\nDu wirst auch reichlich entlohnt mit 10.000$\n\nBist Du dabei?", "Schließen", "Schließen");
	}
	if(missionid == 5)
	{
	ShowPlayerDialog(playerid, DIALOG_MISSION, DIALOG_STYLE_MSGBOX, "Mission 5", "Hey Du!\n\nIch erwarte eine Lieferung mit Waffen.\nKannst Du diese Lieferung abholen?\n\nDie Lieferung kommt am Hafen von Los Santos an\nDu wirst auch reichlich entlohnt mit 10.000$\n\nBist Du dabei?", "Schließen", "Schließen");
	}
	return 1;
}

ocmd:missionstart(playerid, params[])
{
	new missionid;
    if(sscanf(params, "%i", missionid)) return SendClientMessage(playerid, COLOR_GREY, "Verwendung: /missionstart [1-5]");
	if(missionid == 2)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 4.0, 1341.597412, -629.019287, 109.134902))
	    {
	        SendClientMessage(playerid, COLOR_GREY, "Bitte fahre zuerst zum Checkpoint");
			SetPlayerCheckpoint(playerid, 1341.597412, -629.019287, 109.134902, 3.0);
			mis2onCheck1[playerid] = true;
		} else {

		missiontext[playerid] = TextDrawCreate(240.0,580.0,"Hey Du!\n\nIch erwarte eine Lieferung mit Waffen.\nKannst Du diese Lieferung abholen?\n\nDie Lieferung kommt am Hafen von Los Santos an\nDu wirst auch reichlich entlohnt mit 10.000$");
		TextDrawUseBox(missiontext[playerid], 1);
		TextDrawBoxColor(missiontext[playerid], 0x050000FF);
		TextDrawShowForPlayer(playerid, missiontext[playerid]);
		SetPlayerCheckpoint(playerid, 2743.146484, -2453.818603, 13.862256, 3.0);
		mis2onCheck2[playerid] = true;
		}
	}
	return 1;
}

ocmd:mission2(playerid)
{
    SetPlayerPos(playerid, 1341.012451, -626.164428, 109.134902);
    return 1;
}

ocmd:hafen(playerid)
{
    SetPlayerPos(playerid, 2745.605468, -2453.478759, 13.862256);
    return 1;
}

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
