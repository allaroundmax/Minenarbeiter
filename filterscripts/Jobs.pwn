// Benötigte Pakete importieren
#include <a_mysql>
#include <a_samp>
#include <cp>
#include <ocmd>
#include <sscanf2>

// Color-Defines
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00FF
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

// Variablendefinierung
#define BEZIRK_HUNTERQUARRY 0

#define END_MINER_HUNTERQUARRY 0

#undef MAX_PLAYERS
#define MAX_PLAYERS 2

#define DIALOG_JOB 1
#define DIALOG_BERGWERK 2
#define DIALOG_ASK 3

#define VEH_DUMPER 406
#define VEH_DOZER 486

// Enumdefinierung
/*
enum playerJob
{
	Bergwerkarbeiter
}
*/


enum jobPoints
{
	Float:j_x,
	Float:j_y,
	Float:j_z
};


enum playerInventory
{
	Kohleerz,
	Kupfererz,
	Bleierz,
	Eisenerz,
	Golderz,
	Diamanterz,
	Erze,
	Schaufel,
	Spitzhacke
};

enum playerInfo
{
	jobID,
	jobSkill,
	jobEXP,
	jobTimer,
	jobObject,
	jobCP[19],
	jobAnzahl,
	jobBezirk,
	jobCar,
	checkpoint
};

// Variablen Definierung 2
// Alle Farmingspots
new cInfo[][][jobPoints] = {
	{ // Spots aus Hunter Quarry
	    {697.560363, 887.910095, -38.633296},
		{692.148315, 911.092285, -38.700416},
		{679.647277, 930.079284, -40.574451},
		{698.593750, 858.819030, -42.960937},
		{684.323852, 831.947021, -42.960937},
		{661.357421, 805.085205, -42.960937},
		{589.371337, 837.445373, -42.565444},
		{542.039062, 832.137084, -39.932868},
		{538.596496, 829.729675, -39.423931},
		{516.321960, 848.282470, -42.960937},
		{464.189178, 869.328063, -27.731725},
		{458.878540, 887.506774, -27.543518},
		{503.068298, 938.453063, -28.731540},
		{508.406311, 973.876831, -24.396522},
		{535.312988, 969.900207, -21.107778},
		{533.411560, 921.684692, -41.933982},
		{581.856079, 939.525878, -42.649841},
		{609.316528, 953.989562, -33.308609},
		{569.512329, 951.106079, -30.484340},
		{0.0, 0.0, 0.0}
	}
};

// Player Arrays
new pInfo[MAX_PLAYERS][playerInfo];
new pInventory[MAX_PLAYERS][playerInventory];
new bool:cpvor[MAX_PLAYERS], bool:vorarbeiter[MAX_PLAYERS], bool:cpvorende[MAX_PLAYERS], bool:cptorauf[MAX_PLAYERS];
new fence;
new pname[MAX_PLAYERS];
new PlayerText:playerspeed[MAX_PLAYERS];
new getspeed_timer[MAX_PLAYERS];
new dumper1, dumper2, dumper3, dozer1, dozer2, dozer3;


// Actor Arrays
new ActorRalf;


// Funktionsdefinierung
forward gate();
forward getspeed(playerid);
forward erze(playerid);


//forward OnMySQLChecked(playerid);
// PUBLIC FUNCTIONS

// new tGeld = random(50 + pInfo[playerid][pizzaSkill] * 50) + 1;

public erze(playerid)
{
    new pointID = generateMinerCheckpoints(playerid, 0);
	if(pointID != -1)
	{
	    pInfo[playerid][jobAnzahl]--;
	    pInfo[playerid][jobCP][pointID] = 12;

	    if(pInfo[playerid][jobAnzahl] == 0)
	    {
    	     SetPlayerCheckpoint(playerid, 817.424377, 855.650024, 11.865897, 2.0);
    	     SCM(playerid, COLOR_LIGHTBLUE, "Du hast alle Erzvorkommen abgegeben! Kehre nun zurück zu Vorarbeiter Ralf um deinen Lohn zu erhalten.");
    	     pInfo[playerid][checkpoint] = END_MINER_HUNTERQUARRY;
     	}
     	else
     	{
			new msg[128];
			new Erze_ = random(60);
			if(pInfo[playerid][jobSkill] == 1)
			{
				if(Erze_ == 60 && pInventory[playerid][Erze] != 100)
				{
				    new Kohleerz_ = random(60) +1;
				    pInventory[playerid][Kohleerz] += Kohleerz_;
				    pInventory[playerid][Erze] += Kohleerz_;
		  		}
				if(Erze_ == 35 && pInventory[playerid][Erze] != 100)
				{
				    new Kupfererz_ = random(35) +1;
				    pInventory[playerid][Kupfererz] += Kupfererz_;
		  		}
		  		if(Erze_ == 25 && pInventory[playerid][Erze] != 100)
				{
				    new Bleierz_ = random(25) +1;
				    pInventory[playerid][Bleierz] += Bleierz_;
		  		}
		  		if(Erze_ == 20 && pInventory[playerid][Erze] != 100)
				{
				    new Eisenerz_ = random(20) +1;
				    pInventory[playerid][Eisenerz] += Eisenerz_;
		  		}
		  		if(Erze_ == 10 && pInventory[playerid][Erze] != 100)
				{
				    new Golderz_ = random(10) +1;
				    pInventory[playerid][Golderz] += Golderz_;
		  		}
		  	 	if(Erze_ == 5 && pInventory[playerid][Erze] != 100)
				{
				    new Diamanterz_ = random(5) +1;
				    pInventory[playerid][Diamanterz] += Diamanterz_;
		  		}
		  		if(Erze_ == 31)
		  		{
		  		    new findmoney = random(2500) +1;
		  		    GivePlayerMoney(playerid, findmoney);
		  		    format(msg, sizeof(msg), "Du hast %i$ gefunden!", findmoney);
		  		    SCM(playerid, COLOR_YELLOW, msg);
				}
			}

  		    format(msg, sizeof(msg), "Du hast %i Kohleerz/e gefunden.", Kohleerz);
  		    SCM(playerid, COLOR_GREY, msg);
  		    format(msg, sizeof(msg), "Du hast %i Kupfererz/e gefunden.", Kupfererz);
  		    SCM(playerid, COLOR_GREY, msg);
  		    format(msg, sizeof(msg), "Du hast %i Bleierz/e gefunden.", Bleierz);
  		    SCM(playerid, COLOR_GREY, msg);
  		    format(msg, sizeof(msg), "Du hast %i Eisenerz/e gefunden.", Eisenerz);
  		    SCM(playerid, COLOR_GREY, msg);
  		    format(msg, sizeof(msg), "Du hast %i Golderz/e gefunden.", Golderz);
  		    SCM(playerid, COLOR_GREY, msg);
  		    format(msg, sizeof(msg), "Du hast %i Diamanterz/e gefunden.", Diamanterz);
  		    SCM(playerid, COLOR_GREY, msg);

  		    format(msg, sizeof(msg), "Du hast ein eine Mine leergeräumt. Verbleibende Minen: %i", pInfo[playerid][jobAnzahl]);
  		    SCM(playerid, COLOR_GREY, msg);
		}
	}
	return 1;
}




public OnPlayerCommandText(playerid, cmdtext[])
{
	//new playername[MAX_PLAYER_NAME];
	new cmd[256];
	new tmp[256];
	new idx;
	cmd = strtok(cmdtext, idx);
	GetPlayerName(playerid,pname,sizeof(pname));
	if(strcmp(cmd, "/startwork", true) == 0)
	{
	    if(pInfo[playerid][jobID] == 1)
	    {
       		if(pInventory[playerid][Schaufel] == 1 && pInventory[playerid][Spitzhacke] == 1)
   			{
				if(!IsPlayerInRangeOfPoint(playerid, 3, 817.424377, 855.650024, 11.865897))
				{
			    	SCM(playerid, COLOR_GREY, "Fahre zuerst zum Vorarbeiter.");
			    	SetPlayerCheckpoint(playerid, 817.424377, 855.650024, 11.865897, 2.0);
			    	cpvor[playerid] = true;
  				} else {
  				    ShowPlayerDialog(playerid, DIALOG_BERGWERK, DIALOG_STYLE_LIST, "Vorarbeiter Ralf", "Arbeit starten\nArbeit beendet", "Auswählen", "Abbrechen");
	    		}
		    } else if(pInventory[playerid][Schaufel] <= 1 && pInventory[playerid][Spitzhacke] == 0) {
				SCM(playerid, COLOR_LIGHTBLUE, "Du musst dir erst eine Spitzhacke besorgen.");
				SCM(playerid, COLOR_LIGHTBLUE, "Frag den Vorarbeiter ob er Dir eine gibt.");
				SetPlayerCheckpoint(playerid, 817.424377, 855.650024, 11.865897, 2.0);
				cpvor[playerid] = true;
			} else if(pInventory[playerid][Schaufel] == 0 && pInventory[playerid][Spitzhacke] <= 1) {
				SCM(playerid, COLOR_LIGHTBLUE, "Du musst dir erst eine Schaufel besorgen.");
				SCM(playerid, COLOR_LIGHTBLUE, "Frag den Vorarbeiter ob er Dir eine gibt.");
				SetPlayerCheckpoint(playerid, 817.424377, 855.650024, 11.865897, 2.0);
				cpvor[playerid] = true;
			}
		} else {
		    SCM(playerid, COLOR_RED, "Du führst keinen Beruf aus.");
	 	}
	 	return 1;
 	}

 	if(strcmp(cmd, "/job", true) == 0)
 	{
 		ShowPlayerDialog(playerid, DIALOG_JOB, DIALOG_STYLE_LIST, "Berufsauswahl", "Bergwerkarbeiter", "Annehmen", "Abbrechen");
 		return 1;
 	}

 	if(strcmp(cmd, "/job", true) == 0)
 	{
 	    pInventory[playerid][Schaufel] = 0;
		pInventory[playerid][Spitzhacke] = 0;
		return 1;
 	}

 	if(strcmp(cmd, "/sinv", true) == 0)
 	{
 	    pInventory[playerid][Schaufel] = 1;
		pInventory[playerid][Spitzhacke] = 1;
		return 1;
 	}

 	if(strcmp(cmd, "/quitjob", true) == 0)
 	{
 	    if(pInfo[playerid][jobID] != 0)
		{
			SCM(playerid, COLOR_GREY, "Job gekündigt.");
			pInfo[playerid][jobID] = 0;
		} else if(pInfo[playerid][jobID] == 0) {
			SCM(playerid, COLOR_GREY, "Du führst keinen Beruf aus.");
		}
		return 1;
 	}

 	if(strcmp(cmd, "/delveh", true) == 0)
 	{
 	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GREY, "Benutze: /delveh [Car-ID]");
			return 1;
		}

		new car, message[128];
		car = strval(tmp);
		DestroyVehicle(car);
		format(message, sizeof(message), "Du hast ein Fahrzeug mit der Fahrzeug-ID %i zerstört.", car);
		SCM(playerid, COLOR_GREY, message);
		return 1;
 	}

 	if(strcmp(cmd, "/tocp", true) == 0)
 	{
	 	new Float:cpX, Float:cpY, Float:cpZ;
		GetPlayerCheckpointPos(playerid, cpX, cpY, cpZ);

		if(IsPlayerInAnyVehicle(playerid))
		{
		    new vID = GetPlayerVehicleID(playerid);
		    SetVehiclePos(vID, cpX-3, cpY-3, cpZ);
		} else SetPlayerPos(playerid, cpX-3, cpY-3, cpZ);
 	    return 1;
 	}

    if(strcmp(cmd, "/veh", true) == 0)
 	{
 	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GREY, "Benutze: /veh [Car-ID]");
			return 1;
		}

		new car, message[128], Float:playerX, Float:playerY, Float:playerZ;
		car = strval(tmp);

		GetPlayerPos(playerid, playerX, playerY, playerZ);
		CreateVehicle(car, playerX, playerY + 5.0, playerZ, 0, -1, -1, -1);
		format(message, sizeof(message), "Du hast ein Fahrzeug mit der Model-ID %i erstellt.", car);
		SCM(playerid, COLOR_GREY, message);
		return 1;
 	}

 	if(strcmp(cmd, "/fixveh", true) == 0)
 	{
 	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Du bist in keinem Fahrzeug, Spast.");

		new vID;
 	    tmp = strtok(cmdtext, idx);

 	    vID = strval(tmp);
		vID = GetPlayerVehicleID(playerid);
		RepairVehicle(vID);
		SendClientMessage(playerid, COLOR_GREY, "Dein Fahrzeug wurde repariert!");
 		return 1;
 	}

 	if(strcmp(cmd, "/setskin", true) == 0)
 	{
 	    new newskin, player, message[128];
 	    tmp = strtok(cmdtext, idx);
		player = strval(tmp);
		tmp = strtok(cmdtext, idx);
		newskin = strval(tmp);
 	    SetPlayerSkin(player, newskin);
 	    TogglePlayerControllable(player,1);
 	    format(message, sizeof(message), "Du hast Spieler %i den Skin %i gesetzt", player, newskin);
 	    SCM(playerid, COLOR_GREY, message);

		return 1;
 	}

 	if(strcmp(cmd, "/getpos", true) == 0)
 	{
 	    new Float:x, Float:y, Float:z, Float:Angle, msg[128];
		GetPlayerFacingAngle(playerid, Angle);
		GetPlayerPos(playerid, x, y, z);

		format(msg, sizeof(msg), "Position: %f, %f, %f, %f", x, y, z, Angle);
		SendClientMessage(playerid, COLOR_RED, msg);
 		return 1;
	}

 	if(strcmp(cmd, "/goto", true) == 0)
 	{
 	    new targetID, targetName[25], Float:targetX, Float:targetY, Float:targetZ, msg[128];
 	    tmp = strtok(cmdtext, idx);
 	    targetID = strval(tmp);

 	    GetPlayerPos(targetID, targetX, targetY, targetZ);
		SetPlayerPos(playerid, targetX + 0.5, targetY, targetZ);
		GetPlayerName(targetID, targetName, 25);

		format(msg, sizeof(msg), "Du hast dich zu %s teleportiert!", targetName);
		SendClientMessage(playerid, COLOR_GREY, msg);
 	    return 1;
  	}

 	if(strcmp(cmd, "/open", true) == 0)
 	{
 	    MoveObject(fence, 808.29999, 842.70001, 5.4, 5.0);
 	    return 1;
  	}

 	if(strcmp(cmd, "/close", true) == 0)
 	{
   		MoveObject(fence, 808.29999, 842.70001, 11.4, 5.0);
 	    return 1;
  	}

 	if(strcmp(cmd, "/cc", true) == 0)
 	{
 	    for(new i = 0; i < 50; i++) SendClientMessageToAll(COLOR_BLACK, " ");
		return 1;
	}

	if(strcmp(cmd, "/skill1", true) == 0)
 	{
  	  	pInfo[playerid][jobSkill] = 1;
  		SCM(playerid, COLOR_GREEN, "Skill auf 1 gesetzt.");
		return 1;
	}

	if(strcmp(cmd, "/skill5", true) == 0)
 	{
        pInfo[playerid][jobSkill] = 5;
   		SCM(playerid, COLOR_GREEN, "Skill auf 5 gesetzt.");
		return 1;
	}

	if(strcmp(cmd, "/skill10", true) == 0)
 	{
        pInfo[playerid][jobSkill] = 10;
   		SCM(playerid, COLOR_GREEN, "Skill auf 10 gesetzt.");
		return 1;
	}

	if(strcmp(cmd, "/showtd", true) == 0)
	{
		playerspeed[playerid] = CreatePlayerTextDraw(playerid, 30.000000, 100.000000, "Geschwindigkeit: ");
		PlayerTextDrawShow(playerid, playerspeed[playerid]);
		getspeed_timer[playerid] = SetTimerEx("getspeed", 500, true, "i", playerid);
	    return 1;
 	}

    if(strcmp(cmd, "/deltd", true) == 0)
	{
	    PlayerTextDrawDestroy(playerid, playerspeed[playerid]);
	    KillTimer(getspeed_timer[playerid]);
	    return 1;
 	}

	if(strcmp(cmd, "/givexp", true) == 0)
	{
	    givexp(playerid);
	    return 1;
	}

	if(strcmp(cmd, "/xp", true) == 0)
	{
	    new msg[128], exp, skill;
	    exp = pInfo[playerid][jobEXP];
	   	skill = pInfo[playerid][jobSkill];
	    format(msg, sizeof(msg), "Du hast %i EXP und Skill %i", exp, skill);
		SCM(playerid, COLOR_YELLOW, msg);
		return 1;
	}
 	return 1;
}





public getspeed(playerid)
{
	new speedtext[128];
	format(speedtext, sizeof(speedtext), "Geschwindigkeit: %d KM/h", ErmittleGeschwindigkeit(playerid, true));
	PlayerTextDrawSetString(playerid, playerspeed[playerid], speedtext);
}






public OnFilterScriptInit()
{
    SCMTA(COLOR_YELLOW, "Job-Filterscript wird gestartet!");
	// Actor erstellen ( JOB )
	ActorRalf = CreateActor(16, 817.424377, 855.650024, 11.865897, 200.0);
	// Load-Message
 	SCMTA(COLOR_YELLOW, "Job-Filterscript wurde erfolgreich geladen!");
 	fence = CreateObject(980, 808.29999, 842.70001, 11.4, 0, 0, 294.5);

 	// Dumper ( 3 )

	dumper1 = CreateVehicle(406, 773.826354, 796.334289, 2.134384, 55.831447, 1, 1, 180);
 	dumper2 = CreateVehicle(406, 768.894348, 785.241271, 0.386598, 63.813102, 1, 1, 180);
 	dumper3 = CreateVehicle(406, 761.257995, 773.709228, -1.659805, 52.783622, 1, 1, 180);
 	// Dozer ( 3 )
 	dozer1 = CreateVehicle(486, 750.158874, 759.529418, -4.043985, 38.706417, 1, 1, 180);
 	dozer2 = CreateVehicle(486, 743.769409, 753.628112, -4.998408, 39.999885, 1, 1, 180);
 	dozer3 = CreateVehicle(486, 733.725280, 750.425659, -5.995129, 33.231819, 1, 1, 180);





	return 1;
}

public OnFilterScriptExit()
{
	// Actor zerstörung
	DestroyActor(ActorRalf);
	SCMTA(COLOR_RED, "Job-Filterscript wird beendet...");
	SCMTA(COLOR_RED, "Job-Filterscript wurde beendet...");
	DestroyVehicle(dumper1);
	DestroyVehicle(dumper2);
	DestroyVehicle(dumper3);
	DestroyVehicle(dozer1);
	DestroyVehicle(dozer2);
	DestroyVehicle(dozer3);
	DestroyObject(fence);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{

	// Datenbank
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, sizeof(pName));
	vorarbeiter[playerid] = false;
	pInventory[playerid][Spitzhacke] = 1;
	pInventory[playerid][Schaufel] = 1;
	pInfo[playerid][jobID] = 1;
	pInfo[playerid][jobSkill] = 1;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerPos(playerid, 827.772949, 851.326660, 11.871026);
	// Spieler Stargeld geben
	SetPlayerMoney(playerid, 1000000);

	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_JOB)
	{
	    if(response)
	    {
			if(listitem == 0)
			{
				if(pInfo[playerid][jobID] == 0)
				{
				    //new query[128];
 					// Job annehmen
				    SCM(playerid, COLOR_GREY, "Du bist nun ein Bergwerkarbeiter.");
				    SCM(playerid, COLOR_GREY, "Fahre nun nach LV zum Bergwerk um Deine Arbeit mit /startwork zu starten");
				    //format(query, sizeof(query), "UPDATE userfiles SET job = '1' WHERE id = '%i'", pInfo[playerid][dbID]);
				    //mysql_function_query(dbHandle, query, false, "", "");
				    pInfo[playerid][jobID] = 1;
		    	} else if(pInfo[playerid][jobID] != 0) {
		    	    SCM(playerid, COLOR_GREY, "Du führst bereits einen Beruf aus");
				}
			}
		}
	} else if(dialogid == DIALOG_BERGWERK) {
	    if(response)
	    {
	    	if(listitem == 0)
	  		{
     			SCM(playerid, COLOR_GREY, "Gestartet!");
     			SetPlayerCheckpoint(playerid, 815.377624, 845.269165, 10.358113, 2.0);
     			cptorauf[playerid] = true;
			} else if(listitem == 1) {
			    SCM(playerid, COLOR_GREY, "Beendet, gehe nun zu Vorarbeiter Ralf und gib ihm dein Erz.");
			    SetPlayerCheckpoint(playerid, 817.424377, 855.650024, 11.865897, 2.0);
			    cpvorende[playerid] = true;
   			}
     	} else {
			SCM(playerid, COLOR_RED, "Abgebrochen.");
		}
 	} else if(dialogid == DIALOG_ASK) {
 	    if(response)
 	    {
 	        if(listitem == 0 && pInventory[playerid][Schaufel] == 0)
 	        {
 	        	SCM(playerid, COLOR_GREY, "Vorarbeiter Ralf: Na klar hab ich eine Schaufel für dich.");
     			SCM(playerid, COLOR_YELLOW, "Schaufel erhalten");
     			pInventory[playerid][Schaufel] = 1;
 	        } else if(listitem == 1 && pInventory[playerid][Spitzhacke] == 0) {
 	            SCM(playerid, COLOR_GREY, "Vorarbeiter Ralf: Na klar hab ich eine Spitzhacke für dich.");
     			SCM(playerid, COLOR_YELLOW, "Spitzhacke erhalten");
     			pInventory[playerid][Spitzhacke] = 1;
 	        } else if(listitem == 0 && pInventory[playerid][Schaufel] == 1)
 	        {
 	        	SCM(playerid, COLOR_GREY, "Vorarbeiter Ralf: Du brauchst keine neue Schaufel, Du hast bereits eine.");
 	        } else if(listitem == 1 && pInventory[playerid][Spitzhacke] == 1) {
 	            SCM(playerid, COLOR_GREY, "Vorarbeiter Ralf: Du brauchst keine neue Spitzhacke, Du hast bereits eine.");
 	        }
      	}
 	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
	    new vID = GetPlayerVehicleID(playerid);
	    new mID = GetVehicleModel(vID);
	    
	    if(mID == 406 || mID == 486)
	    {
	    
	        if(pInfo[playerid][jobCar] == 0)
	        {
	            //new bezirk = pInfo[playerid][jobBezirk];
	            //new id;
	            //new skill = pInfo[playerid][jobSkill];
	            
       		    pInfo[playerid][jobCar] = vID;
       		    
       		    SCM(playerid, COLOR_LIGHTBLUE, "Begib dich mit dem Fahrzeug zu den Checkpoints.");
			}
		}
	
	    new playerveh, vehicleid;
	    playerveh = GetPlayerVehicleID(playerid);
	    vehicleid = GetVehicleModel(playerveh);
	    if(pInfo[playerid][jobSkill] < 4 && vehicleid == 486)
	    {
		    SCM(playerid, COLOR_GREY, "Du darfst damit noch nicht fahren. Erst ab Skilllevel 4!");
			RemovePlayerFromVehicle(playerid);
		} else if(pInfo[playerid][jobSkill] < 6 && vehicleid == 406)
		{
		    SCM(playerid, COLOR_GREY, "Du darfst damit noch nicht fahren. Erst ab Skilllevel 6!");
			RemovePlayerFromVehicle(playerid);
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(cpvor[playerid])
	{
	    DisablePlayerCheckpoint(playerid);
	    SCM(playerid, COLOR_GREY, "Ziel erreicht.");
	    cpvor[playerid] = false;
	    if(pInventory[playerid][Spitzhacke] <= 1 && pInventory[playerid][Schaufel] == 0 || pInventory[playerid][Spitzhacke] == 0 && pInventory[playerid][Schaufel] <= 1)
	    {
	    ShowPlayerDialog(playerid, DIALOG_ASK, DIALOG_STYLE_LIST, "Vorarbeiter Ralf", "Nach Schaufel fragen\nNach Spitzhacke fragen", "Auswählen", "Abbrechen");
		}
 	} else if(cpvorende[playerid])
 	{
 	    DisablePlayerCheckpoint(playerid);
 	    SCM(playerid, COLOR_GREY, "Vorarbeiter Ralf: Hey, danke für die Erze und das Werkzeug.");
		SCM(playerid, COLOR_GREY, "Vorarbeiter Ralf: Hier ist deine Bezahlung");
        SCM(playerid, COLOR_RED, "FOLGT");
        cpvorende[playerid] = false;

 	} else if(cptorauf[playerid])
 	{
 	    DisablePlayerCheckpoint(playerid);
 		MoveObject(fence, 808.29999, 842.70001, 5.4, 5.0);
 	    cptorauf[playerid] = false;
 	    SetTimer("gate", 5000, false);
 	    if(pInfo[playerid][jobSkill] <= 3)
 	    {
 	        generateMinerCheckpoints(playerid, pInfo[playerid][jobBezirk]);
		    SCM(playerid, COLOR_GREEN, "Du kannst nun alle Checkpoints ablaufen und die Erze fördern.");
   		}
 	} else if(pInfo[playerid][checkpoint] == END_MINER_HUNTERQUARRY)
 	{
 	    if(GetPlayerVehicleID(playerid) != pInfo[playerid][jobCar]) return 1;
 	    
 	    RemovePlayerFromVehicle(playerid);
 	    SetVehicleToRespawn(pInfo[playerid][jobCar]);
 	    
 	    if(pInfo[playerid][jobCar] != 0)
 	    {
 	        SCM(playerid, COLOR_GREEN, "Du bist mit der Tour fertig und hast dein Fahrzeug zurückgebracht.");
 	        SCM(playerid, COLOR_GREEN, "Rede nun mit dem Vorarbeiter Ralf um deine Erze abzugeben.");
 	        pInfo[playerid][jobCar] = 0;
	  	}
 	    
 	    pInfo[playerid][checkpoint] = false;
        DisablePlayerCheckpoint(playerid);

        SCM(playerid, COLOR_GREEN, "Du bist mit der Tour fertig, laufe nun zu Vorarbeiter Ralf um deine Erze abzugeben.");
	}
	return 1;
}

public gate()
{
    MoveObject(fence, 808.29999, 842.70001, 11.4, 5.0);
    return 1;
}



public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	//for(new i = 0; i < MAX_QUEST_VEH; i++) if(vehicleid == qOCarID[i]) SetVehicleParamsForPlayer(vehicleid, forplayerid, false, true);
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}


/*
LoadDatabase(playerid)
{
    new pName[MAX_PLAYER_NAME], query[128];
	GetPlayerName(playerid, pName, sizeof(pName));

	format(query, sizeof(query), "SELECT id, job FROM userfiles WHERE username = '%s'", pName);
	mysql_function_query(dbHandle, query, true, "OnMySQLChecked", "i", playerid);
	return 1;
}
*/
SCM(playerid, color, text[]) return SendClientMessage(playerid, color, text);

SCMTA(color, text[]) return SendClientMessageToAll(color, text);

SetPlayerMoney(playerid, geld)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, geld);
	return 1;
}

strtok(const string1[], &index)
{
	new length = strlen(string1);
	while ((index < length) && (string1[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string1[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string1[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock ErmittleGeschwindigkeit(playerid,bool:kmh) {
    new Float:x,Float:y,Float:z,Float:rtn;
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z); else GetPlayerVelocity(playerid,x,y,z);
    rtn = floatsqroot(x*x+y*y+z*z);
    return kmh?floatround(rtn * 100 * 1.61):floatround(rtn * 100);
}



// eXP

givexp(playerid)
{
	new xp = random(3 + pInfo[playerid][jobSkill]) + 1;
	new msg[128];
	if(pInfo[playerid][jobSkill] < 10)
	{
	    pInfo[playerid][jobEXP] += xp;
		format(msg, sizeof(msg), "Du hast %i EXP erhalten", xp);
		SCM(playerid, COLOR_GREEN, msg);
		if(pInfo[playerid][jobEXP] >= pInfo[playerid][jobSkill] * 100)
		{
			pInfo[playerid][jobSkill]++;
			pInfo[playerid][jobEXP] = 0;
			format(msg, sizeof(msg), "Dein Miner-Skilllevel ist auf Level %i gestiegen!", pInfo[playerid][jobSkill]);
			SCM(playerid, COLOR_YELLOW, msg);
		}
	}
}

generateMinerCheckpoints(playerid, id)
{
	new bool:enthalten;
	new index = 0, maxCPs;
	while(cInfo[id][index][j_x] != 0.0)
	{
		maxCPs++;
		index++;
	}

	for(new i = 0; i < 10; i++)
	{

	    enthalten = true;
	    while(enthalten)
	    {
	        new pointID = random(maxCPs);

	        for(new j = 0; j <8; j++)
	        {

	            if(pointID != pInfo[playerid][jobCP][j])
	            {
       		        pInfo[playerid][jobCP][j] = pointID;
					enthalten = false;
					break;
				}
			}
  		}
	}

	pInfo[playerid][jobAnzahl] = 10;
	return 1;
}
