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
#define COLOR_LIGHTBLUE 0x33CCFFFF
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

// Variablendefinierung
#define DIALOG_QUEST_ASK 0
#define DIALOG_QUEST_ACCEPT 1
#define DIALOG_QUEST_BUY_CHAMBERLAIN 2
#define DIALOG_QUEST_INTERACT 3
#define DIALOG_QUEST_MSG 4
#define DIALOG_QUEST_LAGER 5
#define DIALOG_QUEST_LAGERINHALT 6
#define DIALOG_QUEST_LAGERFISCHE 7
#define DIALOG_QUEST_LAGERNOTHING 8
#define DIALOG_QUEST_LAGERAUSBAU 9
#define DIALOG_QUEST_NEBENSTART 10

#define INV_MAX_FISHES 5

#define ITEM_AIR 0
#define ITEM_FISHES 15

#define ITEM_FISCH_BERNFISCH 1
#define ITEM_FISCH_BLAUERFAECHERFISCH 2
#define ITEM_FISCH_SCHWERTFISCH 3
#define ITEM_FISCH_ZACKENBARSCH 4
#define ITEM_FISCH_ROTERSCHNAPPER 5
#define ITEM_FISCH_KATZENFISCH 6
#define ITEM_FISCH_FORELLE 7
#define ITEM_FISCH_SEGELFISCH 8
#define ITEM_FISCH_HAI 9
#define ITEM_FISCH_DELPHIN 10
#define ITEM_FISCH_MAKRELE 11
#define ITEM_FISCH_HECHT 12
#define ITEM_FISCH_AAL 13
#define ITEM_FISCH_SCHILDKROETE 14
#define ITEM_FISCH_WOLFBARSCH 15
#define ITEM_FISCH_THUNFISCH 16

#define LAGER_MAX_FISHES 50
#define LAGER_MAX_PILZE 100
#define LAGER_MAX_STEINE 20

#undef MAX_PLAYERS
#define MAX_PLAYERS 375

#define MAX_QUESTS 4
#define MAX_QUEST_3DTEXTS 1
#define MAX_QUEST_ACTORS 7
#define MAX_QUEST_OBJECTS 1
#define MAX_QUEST_VEH 2

#define QUEST_RUDOLF_SEEDS 0
#define QUEST_RALF_LKW1 1
#define QUEST_LEWIS_BMX 2
#define QUEST_GEORGE_BLADE 3

#define VEH_BANSHEE 429
#define VEH_BLADE 536
#define VEH_MOUNTAIN_BIKE 510
#define VEH_YANKEE 456

// Enumdefinierung
enum playerInventory
{
	weizensamen,
	truckerRalf,
	bikeParkour,
	autoSchrottplatz,
	
	lagerFischMax,
	lagerPilzMax,
	lagerSteinMax,
	
	lagerFischID[50],
	lagerFischWeight[50],
	
	fischID[5],
	fischWeight[5]
};

enum playerInfo
{
	cdTimer,
	dbID,
	finishTimer,
	oldCarID,
	Float:zustand,

	currentQuestgeber[MAX_PLAYER_NAME],
	questCar,
	Float:questCP,
	questFinish,
	questID,
	questTime,
	talkingTo[MAX_PLAYER_NAME],
	
	nebenquestItem,
	nebenquestAnzahl,
	nebenquestWeightMin,
	nebenquestWeightMax
};

enum quest3DTexts
{
	text3d[128],
	color3d,
	Float:x3d,
	Float:y3d,
	Float:z3d
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
	animLib[32],
	animID[32],
	
	bool:nebenquest,
	nebenquestArt[16]
};

enum questBikeParkour
{
	Float:parkourX,
	Float:parkourY,
	Float:parkourZ,
	beschreibung[192],
};

enum questEnum
{
	owner[MAX_PLAYER_NAME],
	heading[128],
	beschreibung[512]
};

enum questInteract
{
	owner[MAX_PLAYER_NAME],
	interact[256]
};

enum questObjects
{
	objectModel,
	Float:objectX,
	Float:objectY,
	Float:objectZ,
	Float:objectAngX,
	Float:objectAngY,
	Float:objectAngZ
}

enum questOwnerCar
{
	modelID,
	Float:vehicleX,
	Float:vehicleY,
	Float:vehicleZ,
	Float:vehicleAng,
	vehicleColor1,
	vehicleColor2,
	damageTires,
	damageDoors,
	damageLights,
	damagePanels,
	Float:vehicleHealth
};

// Datenbanken
new dbHandle;

// 3DTexte
new quest3D[MAX_QUEST_3DTEXTS][quest3DTexts] = {
	{"Lager für Quest-Objekte\n{FFFFFF}/questlager", COLOR_LIGHTBLUE, -2579.573, 325.276, 11.227}
};
new Text3D:quest3DID[MAX_QUEST_3DTEXTS];

// Quest-Objects
new questObject[MAX_QUEST_OBJECTS][questObjects] = {
	{964, -2579.569, 325.293, 9.562, 0.0, 0.0, 90.0}
};
new questObjectID[MAX_QUEST_OBJECTS];

// Player Arrays
new pInfo[MAX_PLAYERS][playerInfo];
new pInventory[MAX_PLAYERS][playerInventory];

// TextDraw-Arrays
new PlayerText:questTD[MAX_PLAYERS];
new PlayerText:questTDHead[MAX_PLAYERS];
new PlayerText:questTDInfo[MAX_PLAYERS];
new PlayerText:questTDTime[MAX_PLAYERS];

// QuestActor Arrays
new qActor[MAX_QUEST_ACTORS][questActor] = {
	{161, "Rudolf der Bauer", "Rudolf", -52.927, 1.669, 3.117, 124.995, "SMOKING", "M_smklean_loop", false, ""},
	{70, "Mr. Chamberlain", "Chamberlain", 816.003, -1584.539, 13.554, 158.810, "CAMERA", "camstnd_idleloop", false, ""},
	{6, "Ralf der Trucker", "Ralf", 2498.788, -1515.865, 23.984, 318.369, "GANGS", "smkcig_prtl", false, ""},
	{23, "Bike-Profi Lewis", "Lewis", 697.455, -521.477, 16.335, 224.947, "PED", "idle_chat", false, ""},
	{67, "Autohändler George", "George", 2641.358, -2023.460, 13.546, 264.961, "SMOKING", "M_smklean_loop", false, ""},
	{79, "Schrotthändler Harry", "Harry", -1896.156, -1659.730, 23.015, 203.675, "SMOKING", "M_smk_loop", false, ""},
	{15, "Fischer Oliver", "Oliver", -2737.235, 846.788, 59.272, 98.838, "", "", true, "Fischer"}
};
new qActorID[MAX_QUEST_ACTORS];
new Text3D:qActorTextID[MAX_QUEST_ACTORS];

// Quest Array
new quest[MAX_QUESTS][questEnum] = {
	{"Rudolf", "{FFFF00}Quest #1: {FFFFFF}Neue, erntereiche Samensorte\n", "{FFFFFF}Hey, {FFFF00}Mr. Chamberlain {FFFFFF}hat Samen für {FFFF00}Weizen {FFFFFF}genetisch verändert.\nDiese sollen {FFFF00}3x mehr Ertrag {FFFFFF}bringen!\nLeider ist mein {FFFF00}Tampa {FFFFFF}kaputt gegangen und er hat nur\n{FFFF00}begrenzt Samen {FFFFFF}auf Lager. Und diese werden schnell verkauft sein.\n\nKönntest du mir schnell welche kaufen?\nIch zahle dir das {FFFF00}doppelte vom Kaufpreis {FFFFFF}zurück!"},
	{"Ralf", "{FFFF00}Quest #2: {FFFFFF}Überschrittene Fahrzeit\n", "{FFFFFF}Hey du!\n{FFFF00}Mein Chef {FFFFFF}zwingt mich noch eine {FFFF00}Lieferung {FFFFFF}durchzuführen, obwohl\nich meine {FFFF00}Fahrzeit {FFFFFF}schon längst überschritten habe. Hier in der\nGegend sind auch {FFFF00}zu viele Cops{FFFFFF} unterwegs, die mich {FFFF00}kontrollieren{FFFFFF}\nkönnten.\n\nKannst du schnell {FFFF00}meine Lieferung{FFFFFF} übernehmen? Aber mach schnell!\nDer {FFFF00}Käufer {FFFFFF}wartet nicht gerne!"},
	{"Lewis", "{FFFF00}Quest #3: {FFFFFF}Bike-Übungen\n", "{FFFFFF}Hey Alter!\nSoll ich dir zeigen, wie du mit deinem {FFFF00}BMX {FFFFFF}richtig {FFFF00}springst{FFFFFF}?\nUnd willst du auch gleich einen {FFFF00}Parkour durchfahren{FFFFFF}?\n\nDann bist du hier {FFFF00}richtig{FFFFFF}.\nDu bekommst sogar eine {FFFF00}Belohnung{FFFFFF}, wenn du ihn {FFFF00}schaffst{FFFFFF}."},
	{"George", "{FFFF00}Quest #4: {FFFFFF}Autoverschrottung\n", "{FFFFFF}Moin!\nSiehst du den {FFFF00}Blade {FFFFFF}da hinten? Der sieht ziemlich {FFFF00}schäbig{FFFFFF}\naus und kann nicht mehr {FFFF00}gerettet {FFFFFF}werden.\n\n{FFFF00}Harry {FFFFFF}der {FFFF00}Schrotthändler{FFFFFF} weiß schon bescheid.\nWärst du so nett und könntest das {FFFF00}Fahrzeug{FFFFFF} zu {FFFF00}Harry{FFFFFF} bringen?"}
};

// Quest Interact
new qInteract[MAX_QUEST_ACTORS][questInteract] = {
	{"Rudolf", "Weizensamen abgeben"},
	{"Chamberlain", "Maissamen (1575$)\nWeizensamen (2250$)\nRoggensamen (1045$)\nGerstensamen (3410$)"},
	{"Ralf", "LKW-Fahrt beenden"},
	{"Lewis", "BMX-Kurs beenden"},
	{"George", "Banshee abgeben"},
	{"Harry", "Blade abgeben"},
	{"Oliver", "Wenn du diesen Text zu Gesicht bekommst,\ndann hast du 'nen Bug gefunden.\n\nGlückwunsch!"}
};

// Fahrzeuge von Questgebern
new qOCars[MAX_QUEST_VEH][questOwnerCar] = {
	{549, -47.347, -3.143, 2.678, 112.604, 53, 53, 15, 15, 15, 15, 456.9},
	{510, 696.555, -521.477, 15.889, 224.947, 211, 211, 0, 0, 0, 0, 1000.0}
};
new qOCarID[MAX_QUEST_VEH];

// Checkpoint vom BikeParkour
new qBikeParkour[31][questBikeParkour] = {
	{713.2173, -486.2513, 15.7958, "Fahre zum ersten ~y~Checkpoint~w~, um den ~y~Parkour~n~~w~zu beginnen"},
	{713.3908, -466.8724, 18.9497, "Springe jetzt auf den ~y~Wohnwagen"},
	{722.5704, -453.8632, 22.3341, "Begib dich nun auf das ~y~Dach ~w~der ~y~Auto-Werkstatt"},
	{700.5565, -447.3482, 15.9514, "Folge den Weg weiter ueber den ~y~Parkplatz"},
	{687.2892, -447.6032, 19.2610, "Springe ueber die ~y~Kisten ~w~auf den ~y~Vorsprung ~w~des~n~Daches"},
	{683.5734, -471.9359, 24.1785, "Gelange zum ~y~hoechsten Punkt ~w~des Daches"},
	{666.8329, -499.1032, 21.1875, "Springe nun auf das ~y~Dach ~w~des ~y~Barber Shops"},
	{671.0859, -519.5990, 23.4406, "Begib dich ~y~weiter hoch ~w~auf das ~y~Dach"},
	{694.5858, -483.9657, 15.7988, "Begib dich auf die ~y~andere Strassenseite~w~, um den~n~~y~Parkour ~w~fortzusetzen"},
	{693.2904, -505.6789, 19.9396, "Springe nun auf das ~y~Dach gegenueber ~w~der~n~Strassenseite"},
	{703.0569, -527.7517, 15.7962, "Gelange wieder zurueck auf die ~y~Strasse"},
	{700.4038, -540.5096, 19.2057, "Um auf das ~y~Dach ~w~zu gelangen, springe erst auf~n~den ~y~gruenen Vorsprung"},
	{698.5604, -547.1364, 20.9396, "Nun springe auf das ~y~Dach"},
	{701.9658, -631.5692, 24.9539, "Versuche jetzt mit ~y~sehr viel Speed ~w~auf~n~das ~y~Dach ~w~auf der ~y~anderen Strassenseite ~w~zu~n~gelangen. Solltest du es ~y~nicht schaffen~w~,~n~drehe um und versuche es ~y~nochmal"},
	{683.2674, -636.7949, 15.7934, "Folge nun dem ~y~Checkpoint ~w~zum naechsten~n~~y~Objekt"},
	{719.6750, -590.1021, 15.7957, "Folge nun dem ~y~Checkpoint ~w~zum naechsten~n~~y~Objekt"},
	{743.7068, -588.6143, 20.2073, "Springe nun auf das ~y~Dach"},
	{760.8289, -581.0128, 20.7487, "Gelange auf die benachbarte ~y~Garage"},
	{772.2062, -561.7606, 21.9029, "Gelange auf das naechste ~y~Dach"},
	{784.8936, -571.1459, 15.9443, "Begib dich vom ~y~Dach ~w~runter"},
	{800.6795, -567.3555, 19.3938, "Springe auf den ~y~Vorsprung ~w~des ~y~Moebelladens"},
	{808.5266, -554.0356, 19.9430, "Fahre weiter auf das ~y~Dach"},
	{820.0917, -523.7646, 15.9522, "Gelange nun zum naechsten ~y~Checkpoint"},
	{819.8834, -510.7274, 20.1924, "Springe nun auf das ~y~Dach"},
	{791.9172, -507.6147, 20.2079, "Begib dich zum naechsten ~y~Dach"},
	{773.6943, -504.9566, 20.2785, "Springe auf das benachbarte ~y~Dach"},
	{752.8260, -489.1778, 20.8420, "Gelange auf die naechste ~y~Garage"},
	{737.8437, -497.1542, 21.9370, "Begib dich auf das naechste ~y~Dach"},
	{728.2873, -521.1128, 15.9427, "Springe vom ~y~Dach ~w~runter"},
	{696.7850, -520.8043, 19.1393, "Gelange auf den ~y~gelben Vorhang ~w~ueber ~y~Lewis"},
	{698.8423, -523.9998, 15.9572, "Sprich mit ~y~Lewis ~w~um den ~y~Parkour abzuschliessen"}
};

// Namen der Fahrzeuge aus San Andreas
new VehicleNames[][17] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
 	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
 	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
 	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
 	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
 	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
 	"Tiller", "Utility Trailer"
};

// Funktionsdefinierung
forward actorBackInPos();
forward initQuestSystem();
forward finishQuestSound(playerid);
forward OnMySQLChecked(playerid);
forward questCountdown(playerid);
forward unfreezePlayerQuest(playerid);

new engine, lights, alarm, doors, bonnet, boot, objective, bool:boottest[MAX_PLAYERS], vehid;

// Befehle
ocmd:abortanim(playerid)
{
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
	return 1;
}

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

ocmd:cc(playerid)
{
	for(new i = 0; i < 50; i++) SendClientMessageToAll(COLOR_BLACK, " ");
	return 1;
}

ocmd:crossarms(playerid)
{
	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
	return 1;
}

ocmd:fish(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid, 5, -2063.879, 1436.588, 7.100)) return SCM(playerid, COLOR_GREY, "Du bist nicht am Angelsteg!");
	
	new belegt;
	for(new i = 0; i < INV_MAX_FISHES; i++)
	{
		if(pInventory[playerid][fischID][i] != ITEM_AIR) belegt++;
		else break;
		
		if(belegt == 5) return SCM(playerid, COLOR_GREY, "Du kannst nur 5 Fische tragen!");
	}
	
	
	new fishID, fishWeight, fishName[20];
	fishID = random(ITEM_FISHES) + 1;
	fishWeight = random(149) + 1;
	fishName = GetFishNameByID(fishID);
	
	for(new i = 0; i < INV_MAX_FISHES; i++)
	{
	    if(pInventory[playerid][fischID][i] == ITEM_AIR)
	    {
	        pInventory[playerid][fischID][i] = fishID;
	        pInventory[playerid][fischWeight][i] = fishWeight;
			break;
	    }
	}
	
	new msg[128];
	format(msg, sizeof(msg), "Du hast eine/n %s mit %i LBS gefangen!", fishName, fishWeight);
	SCM(playerid, COLOR_LIGHTBLUE, msg);
	return 1;
}

ocmd:fishes(playerid)
{
	new msg[128];
	SCM(playerid, COLOR_LIGHTBLUE, "===============================================");
	
	for(new i = 0; i < INV_MAX_FISHES; i++)
	{
		format(msg, sizeof(msg), "Fisch %i: %s - %i LBS", i + 1, GetFishNameByID(pInventory[playerid][fischID][i]), pInventory[playerid][fischWeight][i]);
		SCM(playerid, COLOR_GREY, msg);
	}
	
	SCM(playerid, COLOR_LIGHTBLUE, "===============================================");
	return 1;
}

ocmd:getpos(playerid)
{
	new Float:x, Float:y, Float:z, Float:ang, msg[128];
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, ang);

	format(msg, sizeof(msg), "Position: X: %.3f, Y: %.3f, Z: %.3f, Angle: %f", x, y, z, ang);
	SendClientMessage(playerid, COLOR_RED, msg);
	return 1;
}

ocmd:heal(playerid)
{
	SetPlayerHealth(playerid, 10000);

	if(IsPlayerInAnyVehicle(playerid)) SetVehicleHealth(GetPlayerVehicleID(playerid), 100000);
	return 1;
}

ocmd:namean(playerid)
{
    for(new i = GetPlayerPoolSize(); i != -1; --i) ShowPlayerNameTagForPlayer(playerid, i, true);
	return 1;
}

ocmd:nameaus(playerid)
{
    for(new i = GetPlayerPoolSize(); i != -1; --i) ShowPlayerNameTagForPlayer(playerid, i, false);
    return 1;
}

ocmd:nebenquest(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_RED, "Fehler: Steige aus dem Fahrzeug aus, um mit der Person zu reden!");
    if(IsPlayerOnQuest(playerid)) return SCM(playerid, COLOR_RED, "Fehler: Du kannst während einer Quest keine Nebenquest annehmen!");
    //if(IsPlayerOnNebenquest(playerid)) return SCM(playerid, COLOR_RED, "Fehler: Du hast bereits eine Nebenquest angenommen!");

	new actorID, actorName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", actorName)) return SCM(playerid, COLOR_GREY, "Verwendung: /nebenquest [Name des Questgebers]");
	actorID = GetActorIDByName(actorName);

	if(!qActor[actorID][nebenquest]) return SCM(playerid, COLOR_GREY, "Dieser Questgeber vergibt keine Nebenquests!");
	pInfo[playerid][talkingTo] = actorName;
	
	if(!IsPlayerInRangeOfPoint(playerid, 5, qActor[actorID][actorX], qActor[actorID][actorY], qActor[actorID][actorZ])) return SCM(playerid, COLOR_GREY, "Du bist zu weit weg, um mit dem Questgeber zu reden!");
	
	if(!strcmp(qActor[actorID][nebenquestArt], "Fischer"))
	{
	    if(pInfo[playerid][nebenquestItem] == ITEM_AIR)
	    {
			new randomFishID, randomFishAnz, randomFishMin, randomFishMax;
			randomFishID = random(ITEM_FISHES) + 1;
			randomFishAnz = random(pInventory[playerid][lagerFischMax] - 5) + 5;
			randomFishMin = random(50) + 50;
			randomFishMax = random(50) + randomFishMin;

			pInfo[playerid][nebenquestItem] = randomFishID;
			pInfo[playerid][nebenquestAnzahl] = randomFishAnz;
			pInfo[playerid][nebenquestWeightMin] = randomFishMin;
			pInfo[playerid][nebenquestWeightMax] = randomFishMax;
		}
		
		new randomMoneyMin, randomMoneyMax;
		randomMoneyMin = pInfo[playerid][nebenquestWeightMin] * pInfo[playerid][nebenquestAnzahl] * GetValueByFishID(pInfo[playerid][nebenquestItem]);
		randomMoneyMax = pInfo[playerid][nebenquestWeightMax] * pInfo[playerid][nebenquestAnzahl] * GetValueByFishID(pInfo[playerid][nebenquestItem]);
		
		new dialogHeading[64], text[256], dialogText[768];
		format(dialogHeading, sizeof(dialogHeading), "{FFFF00}Nebenquest (Fischer): {FFFFFF}%s", actorName);
		
		format(text, sizeof(text), "{FFFFFF}Der {FFFF00}Fischer %s {FFFFFF}benötigt für sein Projekt noch {FFFF00}%i Fische{FFFFFF}.\nDiese müssen {FFFF00}folgende Eigenschaften {FFFFFF}haben:\n \n", actorName, pInfo[playerid][nebenquestAnzahl]);
		strcat(dialogText, text);

		format(text, sizeof(text), "{FFFF00}Art: {FFFFFF}%s\n{FFFF00}Mindestgewicht: {FFFFFF}%i LBS\n{FFFF00}Maximalgewicht: {FFFFFF}%i LBS\n\n", GetFishNameByID(pInfo[playerid][nebenquestItem]), pInfo[playerid][nebenquestWeightMin], pInfo[playerid][nebenquestWeightMax]);
        strcat(dialogText, text);

		format(text, sizeof(text), "{FFFFFF}Wenn du dem Fischer die {FFFF00}gewünschten Fische {FFFFFF}bringst, ist er\nbereit dir {FFFF00}%i$ {FFFFFF}- {FFFF00}%i$ {FFFFFF}zu zahlen.", randomMoneyMin, randomMoneyMax);
		strcat(dialogText, text);
		
		ShowPlayerDialog(playerid, DIALOG_QUEST_NEBENSTART, DIALOG_STYLE_MSGBOX, dialogHeading, dialogText, "Annehmen", "Ablehnen");
	} else SCM(playerid, COLOR_GREY, "Dieser Questgeber bekommt erst später eine Funktion!");
	return 1;
}

ocmd:questabort(playerid)
{
	if(!IsPlayerOnQuest(playerid)) return SCM(playerid, COLOR_RED, "Du hast keine aktive Hauptquest!");
	SCM(playerid, COLOR_GREEN, "Du hast die aktuelle Quest abgebrochen!");
	
 	ResetQuest(playerid);
 	HideQuestText(playerid);
	return 1;
}

ocmd:questlager(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid, 3, -2579.573, 325.276, 11.227)) return SCM(playerid, COLOR_GREY, "Du bist nicht in der Nähe des Lagers!");
	ShowLagerDialog(playerid);
	return 1;
}

ocmd:questtalk(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_RED, "Fehler: Steige aus dem Fahrzeug aus, um mit der Person zu reden!");
	
	new actorID, actorName[MAX_PLAYER_NAME], msg[128];
	if(sscanf(params, "s[24]", actorName)) return SCM(playerid, COLOR_GREY, "Verwendung: /questtalk [Name des Questgebers]");
	actorID = GetActorIDByName(actorName);
	
	if(qActor[actorID][nebenquest]) return SCM(playerid, COLOR_GREY, "Dieser Questgeber vergibt keine Hauptquests!");
	pInfo[playerid][talkingTo] = actorName;
	
	// Wenn Spieler eine Quest hat
	if(IsPlayerOnQuest(playerid))
	{
	    // Wenn Spieler zu weit entfernt ist
	    if(!IsPlayerInRangeOfPoint(playerid, 3, qActor[actorID][actorX], qActor[actorID][actorY], qActor[actorID][actorZ])) return SCM(playerid, COLOR_GREY, "Du bist zu weit entfernt, um mit der Person zu reden!");

		// Wenn kein gültiger Actor eingegeben wurde
		if(actorID == -1)
		{
			format(msg, sizeof(msg), "Es gibt keine Person mit dem Namen %s!", actorName);
			SCM(playerid, COLOR_GREY, msg);
		}
		else
		{
		    new interactHeading[64], interactQuest[256];
		    interactQuest = GetQuestInteraction(actorName);
		    interactHeading = GetQuestInteractHeading(actorName);
		    
		    if(strlen(interactHeading) == 0) SCM(playerid, COLOR_GREY, "Es gibt keinen Grund mit der Person zu reden!");
			else ShowPlayerDialog(playerid, DIALOG_QUEST_INTERACT, DIALOG_STYLE_LIST, interactHeading, interactQuest, "Auswählen", "Abbrechen");
		}
	}
	else
	{
	    // Wenn kein gültiger Actor angegeben wurde
		if(actorID == -1)
		{
		    format(msg, sizeof(msg), "%s ist kein Questgeber!", actorName);
		    SCM(playerid, COLOR_GREY, msg);
		    return 1;
		}
		else
		{
		    // Wenn zu weit weg
		    if(!IsPlayerInRangeOfPoint(playerid, 3, qActor[actorID][actorX], qActor[actorID][actorY], qActor[actorID][actorZ])) return SCM(playerid, COLOR_GREY, "Du bist zu weit entfernt, um mit dem Questgeber zu reden!");

			new questHeading[128], questList[2048];
			for(new i = 0; i < MAX_QUESTS; i++)
			{
			    if(strlen(quest[i][heading]) <= 0) continue;
			    if(!strcmp(quest[i][owner], actorName)) strcat(questList, quest[i][heading], sizeof(questList));
			}

			// Wenn der Actor Quests hat
			if(strlen(questList) != 0)
			{
				format(questHeading, sizeof(questHeading), "{FFFF00}Questübersicht: {FFFFFF}%s", actorName);
				pInfo[playerid][currentQuestgeber] = actorName;

			    ShowPlayerDialog(playerid, DIALOG_QUEST_ASK, DIALOG_STYLE_LIST, questHeading, questList, "Akzeptieren", "Schließen");
			    return 1;
			}
			else
			{
			    format(msg, sizeof(msg), "%s hat zurzeit keine Quests im Angebot!", actorName);
			    SendClientMessage(playerid, COLOR_GREY, msg);
			    return 1;
			}
		}
	}
	return 1;
}


ocmd:releasefish(playerid, params[])
{
	new fishID, msg[128];
	if(sscanf(params, "i", fishID)) return SCM(playerid, COLOR_GREY, "Verwendung: /releasefish [ID]");
	fishID = fishID - 1;

	format(msg, sizeof(msg), "Du hast deine/n %s mit %i LBS weggeschmissen!", GetFishNameByID(pInventory[playerid][fischID][fishID]), pInventory[playerid][fischWeight][fishID]);
	SCM(playerid, COLOR_GREY, msg);

	pInventory[playerid][fischID][fishID] = 0;
	pInventory[playerid][fischWeight][fishID] = 0;

	return 1;
}

ocmd:setskin(playerid, params[])
{
	new skinID;
	if(sscanf(params, "i", skinID)) return SCM(playerid, COLOR_GREY, "Verwendung: /setskin [ID]");
	SetPlayerSkin(playerid, skinID);
	return 1;
}

ocmd:tocp(playerid)
{
	new Float:cpX, Float:cpY, Float:cpZ;
	GetPlayerCheckpointPos(playerid, cpX, cpY, cpZ);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    new vID = GetPlayerVehicleID(playerid);
	    SetVehiclePos(vID, cpX, cpY, cpZ);
	} else SetPlayerPos(playerid, cpX, cpY, cpZ);
	return 1;
}

ocmd:tolager(playerid)
{
	SetPlayerPos(playerid, -2579.569, 325.293, 11.462);
	return 1;
}

ocmd:tosteg(playerid)
{
	SetPlayerPos(playerid, -2063.879, 1436.588, 7.100);
	return 1;
}

ocmd:toquest(playerid, params[])
{
    new actorID, actorName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", actorName)) return SCM(playerid, COLOR_GREY, "Verwendung: /toquest [Name des Questgebers]");
	actorID = GetActorIDByName(actorName);

	if(actorID == -1) SCM(playerid, COLOR_RED, "Keinen Questgeber unter diesem Namen gefunden!");

	if(IsPlayerInAnyVehicle(playerid))
	{
	    new vID = GetPlayerVehicleID(playerid);
	    SetVehiclePos(vID, qActor[actorID][actorX] + 10, qActor[actorID][actorY] + 10, qActor[actorID][actorZ]);
	} else SetPlayerPos(playerid, qActor[actorID][actorX] + 1, qActor[actorID][actorY] + 1, qActor[actorID][actorZ]);
	return 1;
}

ocmd:tpto(playerid, params[])
{
	new pID, Float:targetX, Float:targetY, Float:targetZ;
	if(sscanf(params, "i", pID)) return SCM(playerid, COLOR_GREY, "Verwendung: /tpto [ID]");

	GetPlayerPos(pID, targetX, targetY, targetZ);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    new vID = GetPlayerVehicleID(playerid);
	    SetVehiclePos(vID, targetX, targetY, targetZ + 1);
	} else SetPlayerPos(playerid, targetX, targetY, targetZ + 1);
	return 1;
}

ocmd:waffen(playerid)
{
	ShowPlayerDialog(playerid, 13, DIALOG_STYLE_LIST, "Waffen", "Deagle\nM4\nScharfschützengewehr", "Auswählen", "Abbrechen");
	return 1;
}

ocmd:spawn(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

ocmd:veh(playerid, params[])
{
	new vmID, vID, Float:x, Float:y, Float:z;
	if(sscanf(params, "i", vmID)) return SCM(playerid, COLOR_GREY, "Verwendung: /veh [Model-ID]");
	
	// Fahrzeug an der Stelle spawnen lassen und Spieler reinteleportieren
	GetPlayerPos(playerid, x, y, z);
	vID = CreateVehicle(vmID, x, y, z, 0, -1, -1, -1);
	PutPlayerInVehicle(playerid, vID, 0);
	return 1;
}

public OnFilterScriptInit()
{
	SetWorldTime(20);
	
	// Datenbankanbindung
	dbHandle = mysql_connect("192.168.178.58", "samp", "samp", "123456789");
	
	// Timer setzen
 	SetTimer("actorBackInPos", 3456, true);
 	SetTimer("initQuestSystem", 345, false);
 	
 	// Alle Spieler durchgehen
 	for(new i = 0; i < MAX_PLAYERS; i++)
 	{
 	    if(!IsPlayerConnected(i)) continue;
 	    
	 	ResetQuest(i);
   		LoadDatabase(i);
	}
 	
 	// Actors laden
	for(new i = 0; i < MAX_QUEST_ACTORS; i++)
	{
		qActorID[i] = CreateActor(qActor[i][actorSkin], qActor[i][actorX], qActor[i][actorY], qActor[i][actorZ], qActor[i][actorAng]);
		ApplyActorAnimation(qActorID[i], qActor[i][animLib], qActor[i][animID], 4.1, 1, 0, 0, 0, 0);

		new text[128];
		if(qActor[i][nebenquest]) format(text, sizeof(text), "%s\n{FFFFFF}/nebenquest %s", qActor[i][name], qActor[i][befehlName]);
		else format(text, sizeof(text), "%s\n{FFFFFF}/questtalk %s", qActor[i][name], qActor[i][befehlName]);
		qActorTextID[i] = Create3DTextLabel(text, COLOR_YELLOW, qActor[i][actorX], qActor[i][actorY], qActor[i][actorZ] + 1.2, 7, 0, 1);
	}
	
	// Fahrzeuge der Questowner laden
	for(new i = 0; i < MAX_QUEST_VEH; i++)
	{
		qOCarID[i] = AddStaticVehicleEx(qOCars[i][modelID], qOCars[i][vehicleX], qOCars[i][vehicleY], qOCars[i][vehicleZ], qOCars[i][vehicleAng], qOCars[i][vehicleColor1], qOCars[i][vehicleColor2], -1);
		SetVehicleHealth(qOCarID[i], qOCars[i][vehicleHealth]);
		UpdateVehicleDamageStatus(qOCarID[i], qOCars[i][damagePanels], qOCars[i][damageDoors], qOCars[i][damageLights], qOCars[i][damageTires]);
	}
	
	// Alle Objekte laden
	for(new i = 0; i < MAX_QUEST_OBJECTS; i++) questObjectID[i] = CreateObject(questObject[i][objectModel], questObject[i][objectX], questObject[i][objectY], questObject[i][objectZ], questObject[i][objectAngX], questObject[i][objectAngY], questObject[i][objectAngZ]);
	
	// Alle 3DTexte laden
	for(new i = 0; i < MAX_QUEST_3DTEXTS; i++) quest3DID[i] = Create3DTextLabel(quest3D[i][text3d], quest3D[i][color3d], quest3D[i][x3d], quest3D[i][y3d], quest3D[i][z3d], 10.0, 0, 1);
	
	// Load-Message
 	SendClientMessageToAll(COLOR_YELLOW, "Quest-Filterscript wurde erfolgreich geladen!");
	return 1;
}

public OnFilterScriptExit()
{
	// Actors löschen
	for(new i = 0; i < MAX_QUEST_ACTORS; i++)
	{
		DestroyActor(qActorID[i]);
		Delete3DTextLabel(qActorTextID[i]);
	}
	
	// Alle Spieler durchgehen
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    DestroyQuestText(i);
	    ResetQuest(i);
	}
	
	// Alle QuestCars löschen
	for(new i = 0; i < MAX_QUEST_VEH; i++) DestroyVehicle(qOCarID[i]);
	
	// Alle Objekte löschen
	for(new i = 0; i < MAX_QUEST_OBJECTS; i++) DestroyObject(questObjectID[i]);
	
	// Alle 3DTexte löschen
	for(new i = 0; i < MAX_QUEST_3DTEXTS; i++) Delete3DTextLabel(quest3DID[i]);
	
	// Datenbankanbindung
	mysql_close(dbHandle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	// Questreset
	ResetQuest(playerid);

	// TextDraw erstellen
	CreateQuestText(playerid);
	
	// Datenbank
	LoadDatabase(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	// Questreset
	ResetQuest(playerid);
	
	// TextDraw löschen
	DestroyQuestText(playerid);
	return 1;
}

public OnMySQLChecked(playerid)
{
	new num_rows, num_fields;
	cache_get_data(num_rows, num_fields, dbHandle);
	
	new pName[MAX_PLAYER_NAME], query[128];
 	GetPlayerName(playerid, pName, sizeof(pName));
	
	// Spieler ist noch nicht in der Datenbank vorhanden
	if(num_rows == 0)
	{
	    format(query, sizeof(query), "INSERT INTO userfiles (username, questFinish) VALUES('%s', '-1')", pName);
	    mysql_function_query(dbHandle, query, false, "", "");
	    pInfo[playerid][questFinish] = -1;
	}
	else pInfo[playerid][questFinish] = cache_get_field_content_int(0, "questFinish", dbHandle);
 	pInfo[playerid][dbID] = cache_get_field_content_int(0, "id", dbHandle);
 	
 	pInventory[playerid][lagerFischMax] = cache_get_field_content_int(0, "lagerFischMax", dbHandle);
 	pInventory[playerid][lagerPilzMax] = cache_get_field_content_int(0, "lagerPilzMax", dbHandle);
 	pInventory[playerid][lagerSteinMax] = cache_get_field_content_int(0, "lagerSteinMax", dbHandle);
 	
	if(pInventory[playerid][lagerFischMax] == 0)
	{
		pInventory[playerid][lagerFischMax] = 10;

		format(query, sizeof(query), "UPDATE userfiles SET lagerFischMax = '%i' WHERE id = '%i'", pInventory[playerid][lagerFischMax], pInfo[playerid][dbID]);
		mysql_function_query(dbHandle, query, false, "", "");
	}
	
	if(pInventory[playerid][lagerPilzMax] == 0)
	{
		pInventory[playerid][lagerPilzMax] = 20;

		format(query, sizeof(query), "UPDATE userfiles SET lagerPilzMax = '%i' WHERE id = '%i'", pInventory[playerid][lagerPilzMax], pInfo[playerid][dbID]);
		mysql_function_query(dbHandle, query, false, "", "");
	}
	
	if(pInventory[playerid][lagerSteinMax] == 0)
	{
		pInventory[playerid][lagerSteinMax] = 4;

		format(query, sizeof(query), "UPDATE userfiles SET lagerSteinMax = '%i' WHERE id = '%i'", pInventory[playerid][lagerSteinMax], pInfo[playerid][dbID]);
		mysql_function_query(dbHandle, query, false, "", "");
	}
	
	new fischStrID[256], fischStrWeight[256];
	cache_get_field_content(0, "lagerFischID", fischStrID, dbHandle);
	cache_get_field_content(0, "lagerFischWeight", fischStrWeight, dbHandle);
	
	new fischIDs[LAGER_MAX_FISHES][3], fischWeights[LAGER_MAX_FISHES][4];
	split(fischStrID, fischIDs, ',');
	split(fischStrWeight, fischWeights, ',');
	
	for(new i = 0; i < pInventory[playerid][lagerFischMax]; i++)
	{
		pInventory[playerid][lagerFischID][i] = strval(fischIDs[i]);
		pInventory[playerid][lagerFischWeight][i] = strval(fischWeights[i]);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	// Spieler nähe Rudolf spawnen lassen
	SetPlayerPos(playerid, -56.227, 1.569, 3.117);
	
	// Spieler Stargeld geben
	SetPlayerMoney(playerid, 53451);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 13)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: GivePlayerWeapon(playerid, WEAPON_DEAGLE, 200);
				case 1: GivePlayerWeapon(playerid, WEAPON_M4, 500);
				case 2: GivePlayerWeapon(playerid, WEAPON_SNIPER, 500);
			}
		} else SendClientMessage(playerid, COLOR_RED, "Abgebrochen");
		return 1;
	}
	
	// Alle Quests vom jeweiligen Questgeber anzeigen lassen
	if(dialogid == DIALOG_QUEST_ASK)
	{
	    if(response)
	    {
	        pInfo[playerid][questID] = GetQuestIDByName(GetCurrentQuestgeber(playerid), listitem);
	        
	        if(pInfo[playerid][questID] <= pInfo[playerid][questFinish])
			{
			    pInfo[playerid][questID] = -1;
			    SCM(playerid, COLOR_RED, "Du hast diese Quest bereits abgeschlossen!");
			}
	        else if(pInfo[playerid][questID] > pInfo[playerid][questFinish] + 1)
	        {
	            pInfo[playerid][questID] = -1;
	            
	            new msg[128];
	            format(msg, sizeof(msg), "Du musst erst Quest #%i abschließen, bevor du weiter machen kannst.", pInfo[playerid][questFinish] + 2);
	            SCM(playerid, COLOR_RED, msg);
	        }
	        else
	        {
		        new questHeading[128], questBeschreibung[3072];

		        format(questHeading, sizeof(questHeading), quest[pInfo[playerid][questID]][heading]);
		        format(questBeschreibung, sizeof(questBeschreibung), quest[pInfo[playerid][questID]][beschreibung]);

		        ShowPlayerDialog(playerid, DIALOG_QUEST_ACCEPT, DIALOG_STYLE_MSGBOX, questHeading, questBeschreibung, "Annehmen", "Ablehnen");
		        return 1;
			}
	    }
	}
	
	// Eine Quest akzeptieren
	if(dialogid == DIALOG_QUEST_ACCEPT)
	{
	    if(response)
	    {
	        ShowQuestText(playerid);
	        new currQuest = GetCurrentQuestID(playerid);
	        
	        if(currQuest == QUEST_RUDOLF_SEEDS)
	        {
			    UpdateQuestHeading(playerid, "~y~Quest #1: Neue, erntereiche Samensorte!");
   				UpdateQuestText(playerid, "~w~Mr. Chamberlain wohnt in der Naehe des~n~~y~Burger Shot ~w~in ~y~Marina. Begib dich dort hin~n~und kaufe ~y~5 Paeckchen Weizensamen! ~w~Aber~n~beeile dich, ich weiss nicht wie lange es noch~n~~y~Weizensamen ~w~gibt!");
   				
				SetPlayerCheckpoint(playerid, 816.003, -1584.539, 13.554, 1);
				pInfo[playerid][questCP] = 0.1;
				pInfo[playerid][questTime] = 240;
	        }
	        else if(currQuest == QUEST_RALF_LKW1)
	        {
				UpdateQuestHeading(playerid, "~y~Quest #2: Ueberschrittene Fahrzeit!");
				UpdateQuestText(playerid, "~w~Steig in den ~y~Yankee ~w~links von dir um die ~y~Quest~n~~w~zu beginnen!");
				
				pInfo[playerid][questCar] = CreateVehicle(VEH_YANKEE, 2504.866, -1519.174, 24.069, 0, -1, -1, -1);
				pInfo[playerid][zustand] = 1000;
	        }
	        else if(currQuest == QUEST_LEWIS_BMX)
	        {
	            UpdateQuestHeading(playerid, "~y~Quest #3: Bike-Kurs");
	            UpdateQuestText(playerid, "~w~Steig auf das ~y~Mountain Bike ~w~rechts von dir, um~n~den ~y~Parkour~w~ zu starten!");
	            
	            pInfo[playerid][questCar] = CreateVehicle(VEH_MOUNTAIN_BIKE, 702.006, -523.437, 15.885, 114.999, -1, -1, -1);
	            pInventory[playerid][bikeParkour] = 0;
	        }
	        else if(currQuest == QUEST_GEORGE_BLADE)
	        {
	            UpdateQuestHeading(playerid, "~y~Quest #4: Autoverschrottung");
	            UpdateQuestText(playerid, "~w~Steig in den ~y~Blade~w~, um die Quest zu ~y~beginnen~w~!");
	            
	            pInfo[playerid][questCar] = CreateVehicle(VEH_BLADE, 2652.954, -2038.687, 13.55, 39.221, -1, -1, -1);
	            pInventory[playerid][autoSchrottplatz] = 0;
	        }
	        
	        if(pInfo[playerid][questTime] > 0)
			{
				pInfo[playerid][cdTimer] = SetTimerEx("questCountdown", 1000, true, "i", playerid);
				UpdateQuestTime(playerid, pInfo[playerid][questTime]);
			}
			return 1;
	    }
	    else pInfo[playerid][questID] = -1;
	}
	
	// Während einer Quest mit einem Actor interagieren
	if(dialogid == DIALOG_QUEST_INTERACT)
	{
	    if(response)
	    {
		    new currQuest = GetCurrentQuestID(playerid);
			new actorID = GetCurrentActorIDTalkingTo(playerid);

			// Mit Rudolf reden
			if(actorID == GetActorIDByName("Rudolf"))
			{
			    if(currQuest == QUEST_RUDOLF_SEEDS)
			    {
			        // Weizensamen abgeben
			        if(pInventory[playerid][weizensamen] == 1)
			        {
						SCM(playerid, COLOR_GREEN, "Du hast die Päckchen mit Weizensamen abgegeben und 4500$ erhalten!");
						FinishQuest(playerid, 4500);
					} else SCM(playerid, COLOR_RED, "Du hast nicht die benötigten Päckchen Weizensamen dabei, um die Quest abzuschließen!");
			    }
			}

			// Mit Chamberlain reden
			else if(actorID == GetActorIDByName("Chamberlain"))
			{
			    if(currQuest == QUEST_RUDOLF_SEEDS)
	        	{
		            // Check, ob was gekauft wurde, was nicht benötigt wird
			        if(listitem != 1)
			        {
			            SCM(playerid, COLOR_RED, "Du benötigst dieses Objekt nicht für deine Quest!");
						ShowPlayerDialog(playerid, DIALOG_QUEST_INTERACT, DIALOG_STYLE_LIST, GetQuestInteractHeading("Chamberlain"), GetQuestInteraction("Chamberlain"), "Auswählen", "Abbrechen");
						return 1;
			        }
			        else
			        {
			            if(pInventory[playerid][weizensamen] == 1) SCM(playerid, COLOR_RED, "Du hast bereits Weizensamen gekauft.");
			            else if(GetPlayerMoney(playerid) >= 2250)
			            {
				        	new rudolfID = GetActorIDByName("Rudolf");
							SetPlayerCheckpoint(playerid, qActor[rudolfID][actorX], qActor[rudolfID][actorY], qActor[rudolfID][actorZ], 1);
							pInfo[playerid][questCP] = 0.2;
							pInventory[playerid][weizensamen] = 1;

							GivePlayerMoney(playerid, -2250);
							SCM(playerid, COLOR_GREEN, "Du hast 5 Päckchen Weizensamen für 2250$ gekauft!");
							UpdateQuestText(playerid, "~w~Sehr gut! Bringe die ~y~Weizensamen ~w~zurueck~n~zu ~y~Rudolf, ~w~damit er diese in dem neuen ~n~Jahr zu ~y~Testzwecken ~w~verwenden kann.");
			            }
			            else SCM(playerid, COLOR_RED, "Du hast nicht genügend Geld für die Weizensamen!");
			        }
		        }
			}

			// Mit Ralf während einer Quest interagieren
			else if(actorID == GetActorIDByName("Ralf"))
			{
			    if(currQuest == QUEST_RALF_LKW1)
			    {
			        if(listitem != 0) return SCM(playerid, COLOR_GREY, "Ungültige Auswahl!");
			        
			        // Fahrt erfolgreich beenden
			        if(pInventory[playerid][truckerRalf] == 2)
			        {
						new lohn = floatround(8 * pInfo[playerid][zustand]), msg[128];
						format(msg, sizeof(msg), "Du hast die Fahrt beendet und %i$ erhalten!", lohn);
						SCM(playerid, COLOR_GREEN, msg);
						FinishQuest(playerid, lohn);
			        } else SCM(playerid, COLOR_RED, "Du hast die Fahrt noch nicht beendet!");
			    }
			}

			// Mit Lewis während einer Quest interagieren
			else if(actorID == GetActorIDByName("Lewis"))
			{
			    if(currQuest == QUEST_LEWIS_BMX)
			    {
			        if(listitem != 0) return SCM(playerid, COLOR_GREY, "Ungültige Auswahl!");
			        
			        // Parkour erfolgreich beenden
			        if(pInventory[playerid][bikeParkour] == 30)
			        {
			            SCM(playerid, COLOR_GREEN, "Du hast den Bike-Parkour abgeschlossen und erhälst 5000$!");
						FinishQuest(playerid, 5000);
			        } else SCM(playerid, COLOR_RED, "Du hast den Bike-Parkour noch nicht beendet!");
			    }
			}
			
			// Mit Harry während einer Quest interagieren
			else if(actorID == GetActorIDByName("Harry"))
			{
			    if(currQuest == QUEST_GEORGE_BLADE)
			    {
			        if(listitem == 0)
			        {
			            new dialogText[2048] = "{FFFFFF}Du kommst sicherlich im {FFFF00}Auftrag von George{FFFFFF}, stimmts?\nEr hat mir schon bescheid gesagt, dass du kommst.\nIch werde das {FFFF00}Fahrzeug {FFFFFF}gleich {FFFF00}verschrotten{FFFFFF}.";
			            strcat(dialogText, "\n\n{FFFFFF}Moment mal, ich hab noch {FFFF00}was für dich{FFFFFF}.\nSo ein {FFFF00}alter Schnösel{FFFFFF} kam letztends an und wollte einen\n{FFFF00}Banshee verschrotten{FFFFFF}, obwohl der noch {FFFF00}wie neu {FFFFFF}aussieht.\nVielleicht kann ihn mein {FFFF00}alter Bro George {FFFFFF}noch gebrauchen?");
			            ShowPlayerDialog(playerid, DIALOG_QUEST_MSG, DIALOG_STYLE_MSGBOX, "{FFFF00}Quest #4: {FFFFFF}Autoverschrottung", dialogText, "Schließen", "");
			        }
			    }
			}
			
			// Mit George während einer Quest reden
			else if(actorID == GetActorIDByName("George"))
			{
			    if(currQuest == QUEST_GEORGE_BLADE)
			    {
			        if(listitem == 0) ShowPlayerDialog(playerid, DIALOG_QUEST_MSG, DIALOG_STYLE_MSGBOX, "{FFFF00}Quest #4: {FFFFFF}Autoverschrottung", "{FFFFFF}Hat {FFFF00}Harry {FFFFFF}dir den {FFFF00}Banshee {FFFFFF}mitgegeben?\nWahnsinn! Da muss ich ihn nachher erstmal anrufen!", "Schließen", "");
			    }
			}
		}
	}
	
	// Wenn Gespräche zwischen Spieler und Actor stattfinden
	if(dialogid == DIALOG_QUEST_MSG)
	{
	    new currQuest = GetCurrentQuestID(playerid);
		new actorID = GetCurrentActorIDTalkingTo(playerid);
		
		// Dialog akzeptiert
	    if(response)
	    {
	        // Dialog mit Harry
		    if(actorID == GetActorIDByName("Harry"))
		    {
		        if(currQuest == QUEST_GEORGE_BLADE)
				{
					UpdateQuestText(playerid, "Steige in den ~y~Banshee~w~, um ihn zu ~y~George~n~~w~zu fahren!");
					DestroyVehicle(pInfo[playerid][questCar]);
					pInfo[playerid][questCar] = CreateVehicle(VEH_BANSHEE, -1898.290, -1646.311, 21.750, 270.301, -1, -1, -1);
					pInventory[playerid][autoSchrottplatz] = 2;
				}
		    }
		    
		    // Dialog mit George
		    else if(actorID == GetActorIDByName("George"))
		    {
		        if(currQuest == QUEST_GEORGE_BLADE) FinishQuest(playerid, 7000);
			}
		}
	}
	
	// Mit dem Lager interagieren
	if(dialogid == DIALOG_QUEST_LAGER)
	{
	    if(response)
	    {
		    // Inhalt anzeigen lassen
		    if(listitem == 0)
		    {
				new anzahlFische, lagerFischeStr[1000], lagerInhalt[1024];
				format(lagerFischeStr, sizeof(lagerFischeStr), "{FFFF00}Aktuell gelagerte Fische:\n{FFFFFF}");

				for(new i = 0; i < pInventory[playerid][lagerFischMax]; i++)
				{
				    if(pInventory[playerid][lagerFischID][i] == ITEM_AIR) continue;
				    anzahlFische = anzahlFische + 1;

					new str[100];
					format(str, sizeof(str), "{FFFF00}Fisch {FFFFFF}#%02i:\t{FFFF00}LBS: {FFFFFF}%03i\t{FFFF00}Name: {FFFFFF}%s\n", i + 1, pInventory[playerid][lagerFischWeight][i], GetFishNameByID(pInventory[playerid][lagerFischID][i]));
					strcat(lagerFischeStr, str);
				}

				if(anzahlFische == 0) strcat(lagerFischeStr, "Keine Fische bisher eingelagert.");
				strcat(lagerInhalt, lagerFischeStr);

				ShowPlayerDialog(playerid, DIALOG_QUEST_LAGERINHALT, DIALOG_STYLE_MSGBOX, "{FFFF00}Inhalt des Quest-Lagers", lagerInhalt, "Schließen", "");
		    }

		    // Fische einlagern
		    else if(listitem == 2)
	    	{
	    	    // Falls keine Fische vorhanden sind
			    new belegt;
				for(new i = 0; i < INV_MAX_FISHES; i++) if(pInventory[playerid][fischID][i] != ITEM_AIR) belegt++;
				if(belegt == 0) ShowPlayerDialog(playerid, DIALOG_QUEST_LAGERNOTHING, DIALOG_STYLE_LIST, "{FFFF00}Fische einlagern", "Keine Fische zum Einlagern vorhanden!", "Schließen", "");

				// wenn Fische vorhanden sind
				else
				{
					new listFische[320];
					for(new i = 0; i < INV_MAX_FISHES; i++)
					{
					    new str[64];
					    format(str, sizeof(str), "%s - LBS: %i\n", GetFishNameByID(pInventory[playerid][fischID][i]), pInventory[playerid][fischWeight][i]);
					    strcat(listFische, str);
					}

					ShowPlayerDialog(playerid, DIALOG_QUEST_LAGERFISCHE, DIALOG_STYLE_LIST, "{FFFF00}Fische einlagern", listFische, "Einlagern", "Abbrechen");
				}
			}
			
			// Kapazität ausbauen
			else if(listitem == 6)
			{
			    new dialogText[256];
			    format(dialogText, sizeof(dialogText), "{FFFFFF}Fischkapazität ausbauen (+5 Kapazität)\nAktuell: %i/50\n \nPilzkapazität ausbauen (+10 Kapazität)\nAktuell: %i/100\n \nEdelsteinkapazität ausbauen (+2 Kapazität)\nAktuell: %i/20", pInventory[playerid][lagerFischMax], pInventory[playerid][lagerPilzMax], pInventory[playerid][lagerSteinMax]);
			    ShowPlayerDialog(playerid, DIALOG_QUEST_LAGERAUSBAU, DIALOG_STYLE_LIST, "{FFFF00}Kapazität des Lagers ausbauen", dialogText, "Akzeptieren", "Zurück");
			}
		}
	}
	
	// Wenn der Inhalt angezeigt wurde
	if(dialogid == DIALOG_QUEST_LAGERINHALT) ShowLagerDialog(playerid);
	
	// Wenn nichts eingelagert werden kann
	if(dialogid == DIALOG_QUEST_LAGERNOTHING) ShowLagerDialog(playerid);
	
	// Wenn Fische eingelagert werden
	if(dialogid == DIALOG_QUEST_LAGERFISCHE)
	{
	    if(response)
	    {
			if(pInventory[playerid][fischID][listitem] == ITEM_AIR) SCM(playerid, COLOR_GREY, "Du hast auf diesem Slot keinen Fisch!");
			else
			{
				new belegt;
				for(new i = 0; i < pInventory[playerid][lagerFischMax]; i++)
				{
				    if(pInventory[playerid][lagerFischID][i] == ITEM_AIR)
				    {
				        pInventory[playerid][lagerFischID][i] = pInventory[playerid][fischID][listitem];
				        pInventory[playerid][lagerFischWeight][i] = pInventory[playerid][fischWeight][listitem];
				        break;
				    } else belegt++;
				}
				
				if(belegt == pInventory[playerid][lagerFischMax]) SCM(playerid, COLOR_GREY, "Das Lager ist voll mit Fischen!");
				else
    			{
					new msg[128], query[768];
					format(msg, sizeof(msg), "Du hast deine/n %s mit %i LBS in das Lager gelegt!", GetFishNameByID(pInventory[playerid][fischID][listitem]), pInventory[playerid][fischWeight][listitem]);
					SCM(playerid, COLOR_LIGHTBLUE, msg);

					new fischStrID[256], fischStrWeight[256];
					new currFishIDStr[10], currFishWeightStr[10];

					for(new i = 0; i < LAGER_MAX_FISHES - 1; i++)
					{
						format(currFishIDStr, 10, "%i,", pInventory[playerid][lagerFischID][i]);
						format(currFishWeightStr, 10, "%i,", pInventory[playerid][lagerFischWeight][i]);
						
					    strcat(fischStrID, currFishIDStr);
					    strcat(fischStrWeight, currFishWeightStr);
					}
					
					format(currFishIDStr, 10, "%i", pInventory[playerid][lagerFischID][LAGER_MAX_FISHES - 1]);
					format(currFishWeightStr, 10, "%i", pInventory[playerid][lagerFischWeight][LAGER_MAX_FISHES - 1]);

					strcat(fischStrID, currFishIDStr);
					strcat(fischStrWeight, currFishWeightStr);
					
					pInventory[playerid][fischID][listitem] = ITEM_AIR;
					pInventory[playerid][fischWeight][listitem] = 0;
					
					format(query, sizeof(query), "UPDATE userfiles SET lagerFischID = '%s', lagerFischWeight = '%s' WHERE id = '%i'", fischStrID, fischStrWeight, pInfo[playerid][dbID]);
					mysql_function_query(dbHandle, query, false, "", "");
				}
			}
			
			new listFische[320];
			for(new i = 0; i < INV_MAX_FISHES; i++)
			{
			    new str[64];
			    format(str, sizeof(str), "%s - LBS: %i\n", GetFishNameByID(pInventory[playerid][fischID][i]), pInventory[playerid][fischWeight][i]);
			    strcat(listFische, str);
			}

			ShowPlayerDialog(playerid, DIALOG_QUEST_LAGERFISCHE, DIALOG_STYLE_LIST, "{FFFF00}Fische einlagern", listFische, "Einlagern", "Abbrechen");
	    }
	    else ShowLagerDialog(playerid);
	}
	
	// Wenn man die Kapazität ausbaut
	if(dialogid == DIALOG_QUEST_LAGERAUSBAU)
	{
	    if(response)
	    {
	    
		} else ShowLagerDialog(playerid);
	}
	return 0;
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

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
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
	// Wenn der Spieler in ein Fahrzeug einsteigt
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
    {
		new currQuest = GetCurrentQuestID(playerid), vID = GetPlayerVehicleID(playerid);
		pInfo[playerid][oldCarID] = vID;
		if(vID != pInfo[playerid][questCar]) return 1;
		
	    // Während der Quest von Ralf (LKW-Lieferung #1)
	    if(currQuest == QUEST_RALF_LKW1)
	    {
		    if(pInventory[playerid][truckerRalf] == 0)
		    {
		       	SetPlayerCheckpoint(playerid, -227.284, 1073.701, 19.742, 7);
		    	pInfo[playerid][questCP] = 1.1;
			    UpdateQuestText(playerid, "~w~Fahre die ~y~Ladung ~w~mit dem ~y~Yankee ~w~zum~n~Abgabeort nach ~y~Fort Carson~w~!~n~~n~Aber beachte! Dein Lohn haengt vom ~y~Zustand ~w~der~n~Ware ab! Also fahre vorsichtig!");
		    }
		    else if(pInventory[playerid][truckerRalf] == 1)
		    {
     			SetPlayerCheckpoint(playerid, 2504.866, -1519.174, 24.069, 7);
				pInfo[playerid][questCP] = 1.2;
				UpdateQuestText(playerid, "~w~Begib dich zurueck zu ~y~Ralf~w~, damit er~n~weiss, dass du die ~y~Ware ~w~abgeliefert hast!");
		    }
		}
		
		// Während des Bike-Parkours von Lewis
		else if(currQuest == QUEST_LEWIS_BMX)
		{
		    new parkourID = pInventory[playerid][bikeParkour];
			SetPlayerCheckpoint(playerid, qBikeParkour[parkourID][parkourX], qBikeParkour[parkourID][parkourY], qBikeParkour[parkourID][parkourZ], 1);
			pInfo[playerid][questCP] = 2.0;
			
			new text[256];
			format(text, sizeof(text), "~w~%s~w~!~n~~n~~y~Checkpoint #~w~%i ~y~/ #~w~31", qBikeParkour[parkourID][beschreibung], parkourID + 1);
			UpdateQuestText(playerid, text);
		}
		
		// Während der Autoverschrottung von George
		else if(currQuest == QUEST_GEORGE_BLADE)
		{
		    if(pInventory[playerid][autoSchrottplatz] == 0)
		    {
			    SetPlayerCheckpoint(playerid, -1901.372, -1662.727, 23.015, 5);
			    pInfo[playerid][questCP] = 3.1;
			    UpdateQuestText(playerid, "~w~Fahre den ~y~Blade ~w~zu der ~y~Schrottpresse ~w~in der~n~Naehe von ~y~Angle Pine~w~!");
			}
			else if(pInventory[playerid][autoSchrottplatz] == 2)
			{
			    SetPlayerCheckpoint(playerid, 2644.776, -2027.976, 13.546, 5);
			    pInfo[playerid][questCP] = 3.2;
			    UpdateQuestText(playerid, "~w~Fahre den ~y~Banshee ~w~wieder zurueck zu ~y~George~n~~w~um die Quest ~y~abzuschliessen~w~!");
			}
		}
    }
    // Wenn der Spieler aus einem Fahrzeug steigt
    else if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
	    if(pInventory[playerid][truckerRalf]) return 1;
	    if(pInventory[playerid][bikeParkour]) return 1;
		if(pInventory[playerid][autoSchrottplatz] == 1 || pInventory[playerid][autoSchrottplatz] == 3) return 1;
		
	    if(pInfo[playerid][oldCarID] != pInfo[playerid][questCar]) return 1;
	    if(pInfo[playerid][questCar] == 0) return 1;
	    
		DisablePlayerCheckpoint(playerid);
		pInfo[playerid][questCP] = 0;
		
		new model = GetVehicleModel(pInfo[playerid][questCar]);
		if(model == VEH_MOUNTAIN_BIKE) UpdateQuestText(playerid, "~w~Steige wieder auf das ~y~Mountain Bike~w~,~n~um die ~y~Quest ~w~fortzusetzen!");
		else
		{
			new text[128];
			format(text, sizeof(text), "~w~Steige wieder in den ~y~%s ~w~ein, um die~n~~y~Quest~w~ fortzusetzen!", GetVehicleNameByID(model));
   			UpdateQuestText(playerid, text);
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	new Float:cpID = pInfo[playerid][questCP];
	if(cpID == 0.1)
	{
		DisablePlayerCheckpoint(playerid);
		DestroyQuestCountdown(playerid);
		UpdateQuestText(playerid, "~w~Rede mit ~y~Mr. Chamberlain ~w~um Weizensamen~n~von ihm zu kaufen!");
	}
	else if(cpID == 0.2)
	{
		DisablePlayerCheckpoint(playerid);
		UpdateQuestText(playerid, "~w~Nutze den Befehl ~y~/questtalk~w~ um ~y~Rudolf~w~~n~die ~y~gekaufen Weizensamen ~w~von ~y~Mr. Chamberlain~n~~w~zu geben und die Quest ~y~abzuschliessen~w~!");
	}
	else if(cpID == 1.1)
	{
	    DisablePlayerCheckpoint(playerid);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("unfreezePlayerQuest", 6000, false, "i", playerid);
		pInventory[playerid][truckerRalf] = 1;
		UpdateQuestText(playerid, "~w~Bitte warte, bis das Fahrzeug ~y~entladen ~w~wurde!");
	}
	else if(cpID == 1.2)
	{
		RemovePlayerFromVehicle(playerid);
	    SetVehicleParamsForPlayer(pInfo[playerid][questCar], playerid, false, true);
	    
		DisablePlayerCheckpoint(playerid);
		pInfo[playerid][questCP] = 0;
		pInventory[playerid][truckerRalf] = 2;
		UpdateQuestText(playerid, "~w~Rede mit ~y~Ralf, ~w~um die Quest ~y~abzuschliessen~w~!");
	}
	else if(cpID == 2.0)
	{
	    new parkourID = pInventory[playerid][bikeParkour] + 1;
	    
	    if(parkourID == 31)
		{
			DisablePlayerCheckpoint(playerid);
			pInfo[playerid][questCP] = 0;
		}
	    else
	    {
			pInventory[playerid][bikeParkour] = parkourID;
		    SetPlayerCheckpoint(playerid, qBikeParkour[parkourID][parkourX], qBikeParkour[parkourID][parkourY], qBikeParkour[parkourID][parkourZ], 1);

		    new text[256];
			format(text, sizeof(text), "~w~%s~w~!~n~~n~~y~Checkpoint #~w~%i ~y~/ #~w~31", qBikeParkour[parkourID][beschreibung], parkourID + 1);
			UpdateQuestText(playerid, text);
		}
	}
	else if(cpID == 3.1)
	{
	    RemovePlayerFromVehicle(playerid);
	    SetVehicleParamsForPlayer(pInfo[playerid][questCar], playerid, false, true);
	    
	    DisablePlayerCheckpoint(playerid);
	    pInfo[playerid][questCP] = 0;
	    pInventory[playerid][autoSchrottplatz] = 1;
	    UpdateQuestText(playerid, "~w~Rede mit ~y~Harry~w~, um die Quest ~y~fortzusetzen~w~!");
	}
	else if(cpID == 3.2)
	{
	    RemovePlayerFromVehicle(playerid);
	    SetVehicleParamsForPlayer(pInfo[playerid][questCar], playerid, false, true);
	    
	    DisablePlayerCheckpoint(playerid);
	    pInfo[playerid][questCP] = 0;
	    pInventory[playerid][autoSchrottplatz] = 3;
	    UpdateQuestText(playerid, "~w~Rede mit ~y~George~w~, um die Quest ~y~abzuschliessen~w~!");
	}
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
	// Zustand der Ware speichern
	new currQuest = GetCurrentQuestID(playerid);
	if(currQuest == QUEST_RALF_LKW1 && !pInventory[playerid][truckerRalf] && IsPlayerInVehicle(playerid, pInfo[playerid][questCar]))
	{
		new Float:vHealth, vID = GetPlayerVehicleID(playerid);
		GetVehicleHealth(vID, vHealth);

		if(vHealth == 0) return 1;
		else if(vHealth < 250) FailQuest(playerid, "Der Yankee wurde zerstört!");
		else if(vHealth < pInfo[playerid][zustand]) pInfo[playerid][zustand] = vHealth;
	}
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
	for(new i = 0; i < MAX_QUEST_VEH; i++) if(vehicleid == qOCarID[i]) SetVehicleParamsForPlayer(vehicleid, forplayerid, false, true);
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

public actorBackInPos()
{
	// Actors zurück in Position bringen
	for(new i = 0; i < MAX_QUEST_ACTORS; i++)
	{
	    SetActorPos(i, qActor[i][actorX], qActor[i][actorY], qActor[i][actorZ]);
		SetActorFacingAngle(i, qActor[i][actorAng]);
		ApplyActorAnimation(qActorID[i], qActor[i][animLib], qActor[i][animID], 4.1, 1, 0, 0, 0, 0);
	}
	
	// Fahrzeuge der Questgeber zurück in Position
	for(new i = 0; i < MAX_QUEST_VEH; i++)
	{
	    SetVehicleZAngle(qOCarID[i], qOCars[i][vehicleAng]);
	    SetVehiclePos(qOCarID[i], qOCars[i][vehicleX], qOCars[i][vehicleY], qOCars[i][vehicleZ]);
		SetVehicleHealth(qOCarID[i], qOCars[i][vehicleHealth]);
		UpdateVehicleDamageStatus(qOCarID[i], qOCars[i][damagePanels], qOCars[i][damageDoors], qOCars[i][damageLights], qOCars[i][damageTires]);
	}
	return 1;
}

public finishQuestSound(playerid)
{
    PlayerPlaySound(playerid, 1098, 0.0, 0.0, 0.0);
    return 1;
}

public initQuestSystem()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    
	    // Alle Quests abbrechen
		ResetQuest(i);
		
		// TextDraw erstellen
		CreateQuestText(i);
	}
	return 1;
}

public questCountdown(playerid)
{
	pInfo[playerid][questTime]--;
	
	if(pInfo[playerid][questTime] == 0) FailQuest(playerid, "Die Zeit ist abgelaufen!");
	else UpdateQuestTime(playerid, pInfo[playerid][questTime]);
	return 1;
}

public unfreezePlayerQuest(playerid)
{
	TogglePlayerControllable(playerid, 1);
	
	new currQuest = GetCurrentQuestID(playerid);
	if(currQuest == QUEST_RALF_LKW1)
	{
		SetPlayerCheckpoint(playerid, 2504.866, -1519.174, 24.069, 7);
		pInfo[playerid][questCP] = 1.2;
		UpdateQuestText(playerid, "~w~Begib dich zurueck zu ~y~Ralf~w~, damit er~n~weiss, dass du die ~y~Ware ~w~abgeliefert hast!");
	}
	return 1;
}

CreateQuestText(playerid)
{
	// TextDraw-Hintergrund erstellen
    questTD[playerid] = CreatePlayerTextDraw(playerid, 630.000000, 325.000000, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	PlayerTextDrawBackgroundColor(playerid, questTD[playerid], 255);
	PlayerTextDrawFont(playerid, questTD[playerid], 1);
	PlayerTextDrawLetterSize(playerid, questTD[playerid], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, questTD[playerid], -256);
	PlayerTextDrawSetOutline(playerid, questTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, questTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, questTD[playerid], 0);
	PlayerTextDrawUseBox(playerid, questTD[playerid], 1);
	PlayerTextDrawBoxColor(playerid, questTD[playerid], 0x000000CC);
	PlayerTextDrawTextSize(playerid, questTD[playerid], 460.000000, 26.000000);
	PlayerTextDrawSetSelectable(playerid, questTD[playerid], 0);

	// TextDraw-Heading erstellen
    questTDHead[playerid] = CreatePlayerTextDraw(playerid, 464.000000, 325.000000, "");
	PlayerTextDrawBackgroundColor(playerid, questTDHead[playerid], 255);
	PlayerTextDrawFont(playerid, questTDHead[playerid], 1);
	PlayerTextDrawLetterSize(playerid, questTDHead[playerid], 0.200000, 0.899999);
	PlayerTextDrawColor(playerid, questTDHead[playerid], -1);
	PlayerTextDrawSetOutline(playerid, questTDHead[playerid], 0);
	PlayerTextDrawSetProportional(playerid, questTDHead[playerid], 1);
	PlayerTextDrawSetShadow(playerid, questTDHead[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, questTDHead[playerid], 0);

	// TextDraw-Text erstellen
	questTDInfo[playerid] = CreatePlayerTextDraw(playerid, 464.000000, 340.000000, "");
	PlayerTextDrawBackgroundColor(playerid, questTDInfo[playerid], 255);
	PlayerTextDrawFont(playerid, questTDInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, questTDInfo[playerid], 0.200000, 0.899999);
	PlayerTextDrawColor(playerid, questTDInfo[playerid], -1);
	PlayerTextDrawSetOutline(playerid, questTDInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, questTDInfo[playerid], 1);
	PlayerTextDrawSetShadow(playerid, questTDInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, questTDInfo[playerid], 0);

	// TextDraw-Countdown erstellen
	questTDTime[playerid] = CreatePlayerTextDraw(playerid, 464.000000, 420.000000, "");
	PlayerTextDrawBackgroundColor(playerid, questTDTime[playerid], 255);
	PlayerTextDrawFont(playerid, questTDTime[playerid], 1);
	PlayerTextDrawLetterSize(playerid, questTDTime[playerid], 0.200000, 0.899999);
	PlayerTextDrawColor(playerid, questTDTime[playerid], -1);
	PlayerTextDrawSetOutline(playerid, questTDTime[playerid], 0);
	PlayerTextDrawSetProportional(playerid, questTDTime[playerid], 1);
	PlayerTextDrawSetShadow(playerid, questTDTime[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, questTDTime[playerid], 0);
	return 1;
}

DestroyQuestCountdown(playerid)
{
	PlayerTextDrawDestroy(playerid, questTDTime[playerid]);
	KillTimer(pInfo[playerid][cdTimer]);
	pInfo[playerid][questTime] = 0;
	return 1;
}

DestroyQuestText(playerid)
{
	PlayerTextDrawDestroy(playerid, questTD[playerid]);
	PlayerTextDrawDestroy(playerid, questTDHead[playerid]);
	PlayerTextDrawDestroy(playerid, questTDInfo[playerid]);
	PlayerTextDrawDestroy(playerid, questTDTime[playerid]);
	return 1;
}

FailQuest(playerid, fail[])
{
    pInfo[playerid][questID] = -1;
	pInfo[playerid][questTime] = 0;
	HideQuestText(playerid);
	
	DisablePlayerCheckpoint(playerid);
	pInfo[playerid][questCP] = 0;
	
	GameTextForPlayer(playerid, "~r~Quest fehlgeschlagen!", 9000, 0);

	new msg[128];
	format(msg, sizeof(msg), "Quest fehlgeschlagen! %s", fail);
	SCM(playerid, COLOR_RED, msg);
	
	KillTimer(pInfo[playerid][cdTimer]);
	DestroyVehicle(pInfo[playerid][questCar]);
	pInfo[playerid][questCar] = 0;
	return 1;
}

FinishQuest(playerid, geld)
{
	HideQuestText(playerid);
	pInfo[playerid][questFinish] = pInfo[playerid][questID];
	pInfo[playerid][questID] = -1;
	
	if(pInfo[playerid][questCar] != 0) DestroyVehicle(pInfo[playerid][questCar]);
	pInfo[playerid][questCar] = 0;
	
	PlayerPlaySound(playerid, 1097, 0.0, 0.0, 0.0);
	GivePlayerMoney(playerid, geld);
	
	new text[32], query[128];
	format(query, sizeof(query), "UPDATE userfiles SET questFinish = '%i' WHERE id = '%i'", pInfo[playerid][questFinish], pInfo[playerid][dbID]);
	format(text, sizeof(text), "~y~Quest beendet!~n~~w~%i$", geld);

	mysql_function_query(dbHandle, query, false, "", "");
	GameTextForPlayer(playerid, text, 7500, 0);
	
	SetTimerEx("finishQuestSound", 8500, false, "i", playerid);
	return 1;
}

GetActorByQuestID(id)
{
	new actor[MAX_PLAYER_NAME];
	format(actor, sizeof(actor), "%s", quest[id][owner]);
	
	return actor;
}

GetActorIDByName(actorName[])
{
	for(new i = 0; i < MAX_QUEST_ACTORS; i++)
	{
	    if(strlen(qActor[i][befehlName]) <= 0) continue;
	    if(!strcmp(qActor[i][befehlName], actorName, true)) return i;
	}
	return -1;
}

GetCurrentActorIDTalkingTo(playerid) return GetActorIDByName(pInfo[playerid][talkingTo]);

GetCurrentQuestID(playerid)
{
	return pInfo[playerid][questID];
}

GetCurrentQuestgeber(playerid)
{
	new questgeber[MAX_PLAYER_NAME];
	format(questgeber, sizeof(questgeber), "%s", pInfo[playerid][currentQuestgeber]);
	
	return questgeber;
}

GetFishNameByID(id)
{
	new fishName[20];
	if(id == ITEM_AIR) format(fishName, 20, "Nichts");
	else if(id == ITEM_FISCH_BERNFISCH) format(fishName, 20, "Bernfisch");
	else if(id == ITEM_FISCH_BLAUERFAECHERFISCH) format(fishName, 20, "Blauer Fächerfisch");
	else if(id == ITEM_FISCH_SCHWERTFISCH) format(fishName, 20, "Schwertfisch");
	else if(id == ITEM_FISCH_ZACKENBARSCH) format(fishName, 20, "Zackenbarsch");
	else if(id == ITEM_FISCH_ROTERSCHNAPPER) format(fishName, 20, "Roter Schnapper");
	else if(id == ITEM_FISCH_KATZENFISCH) format(fishName, 20, "Katzenfisch");
	else if(id == ITEM_FISCH_FORELLE) format(fishName, 20, "Forelle");
	else if(id == ITEM_FISCH_SEGELFISCH) format(fishName, 20, "Segelfisch");
	else if(id == ITEM_FISCH_HAI) format(fishName, 20, "Hai");
	else if(id == ITEM_FISCH_DELPHIN) format(fishName, 20, "Delphin");
	else if(id == ITEM_FISCH_MAKRELE) format(fishName, 20, "Makrele");
	else if(id == ITEM_FISCH_HECHT) format(fishName, 20, "Hecht");
	else if(id == ITEM_FISCH_AAL) format(fishName, 20, "Aal");
	else if(id == ITEM_FISCH_SCHILDKROETE) format(fishName, 20, "Schildkröte");
	else if(id == ITEM_FISCH_WOLFBARSCH) format(fishName, 20, "Wolfbarsch");
	else if(id == ITEM_FISCH_THUNFISCH) format(fishName, 20, "Thunfisch");
	
	return fishName;
}

GetQuestIDByName(questgeber[], id)
{
	new indexQuest = -1;
	for(new i = 0; i < MAX_QUESTS; i++)
	{
	    if(!strcmp(GetActorByQuestID(i), questgeber))
	    {
	        indexQuest++;
	        if(indexQuest == id) return i;
	    }
	}
	return -1;
}

GetQuestInteractHeading(questgeber[])
{
	new interactHeading[64];
	format(interactHeading, sizeof(interactHeading), "{FFFF00}Interaktionsmenü: {FFFFFF}%s", questgeber);
	return interactHeading;
}

GetQuestInteraction(questgeber[])
{
	new interactQuest[256];
	for(new i = 0; i < MAX_QUEST_ACTORS; i++)
	{
		if(!strcmp(questgeber, qInteract[i][owner]))
		{
		    format(interactQuest, sizeof(interactQuest), "{FFFFFF}%s", qInteract[i][interact]);
		    return interactQuest;
		}
	}
	
	format(interactQuest, sizeof(interactQuest), "");
	return interactQuest;
}

GetValueByFishID(id)
{
	if(id == ITEM_AIR) return -1;
	else if(id == ITEM_FISCH_BERNFISCH) return 1;
	else if(id == ITEM_FISCH_BLAUERFAECHERFISCH) return 2;
	else if(id == ITEM_FISCH_SCHWERTFISCH) return 3;
	else if(id == ITEM_FISCH_ZACKENBARSCH) return 3;
	else if(id == ITEM_FISCH_ROTERSCHNAPPER) return 3;
	else if(id == ITEM_FISCH_KATZENFISCH) return 4;
	else if(id == ITEM_FISCH_FORELLE) return 5;
	else if(id == ITEM_FISCH_SEGELFISCH) return 7;
	else if(id == ITEM_FISCH_HAI) return 7;
	else if(id == ITEM_FISCH_DELPHIN) return 7;
	else if(id == ITEM_FISCH_MAKRELE) return 8;
	else if(id == ITEM_FISCH_HECHT) return 9;
	else if(id == ITEM_FISCH_AAL) return 9;
	else if(id == ITEM_FISCH_SCHILDKROETE) return 10;
	else if(id == ITEM_FISCH_WOLFBARSCH) return 12;
	else if(id == ITEM_FISCH_THUNFISCH) return 12;
	else return -1;
}

GetVehicleName(vehicleid)
{
	new vName[25];
	format(vName, sizeof(vName), "%s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
	return vName;
}

GetVehicleNameByID(model)
{
	new vName[25];
	format(vName, sizeof(vName), "%s", VehicleNames[model - 400]);
	return vName;
}

HideQuestText(playerid)
{
	// Alle TextDraws verstecken
	PlayerTextDrawHide(playerid, questTD[playerid]);
	PlayerTextDrawHide(playerid, questTDHead[playerid]);
	PlayerTextDrawHide(playerid, questTDInfo[playerid]);
	PlayerTextDrawHide(playerid, questTDTime[playerid]);

	// Strings in den TextDraws zurücksetzen
	PlayerTextDrawSetString(playerid, questTD[playerid], "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	PlayerTextDrawSetString(playerid, questTDInfo[playerid], " ");
	PlayerTextDrawSetString(playerid, questTDHead[playerid], " ");
	PlayerTextDrawSetString(playerid, questTDTime[playerid], " ");
	return 1;
}

IsPlayerOnNebenquest(playerid)
{
	if(pInfo[playerid][nebenquestItem] != ITEM_AIR) return 1;
	return 0;
}

IsPlayerOnQuest(playerid)
{
	if(pInfo[playerid][questID] != -1) return 1;
	return 0;
}

LoadDatabase(playerid)
{
    new pName[MAX_PLAYER_NAME], query[128];
	GetPlayerName(playerid, pName, sizeof(pName));
	
	format(query, sizeof(query), "SELECT * FROM userfiles WHERE username = '%s'", pName);
	mysql_function_query(dbHandle, query, true, "OnMySQLChecked", "i", playerid);
	return 1;
}

ResetQuest(playerid)
{
	pInfo[playerid][questID] = -1;
	pInfo[playerid][questCP] = -1;
	SetPlayerVirtualWorld(playerid, 0);
	
	if(pInfo[playerid][questCar] != 0)
	{
	    DestroyVehicle(pInfo[playerid][questCar]);
	    pInfo[playerid][questCar] = 0;
	}
	
	DisablePlayerCheckpoint(playerid);
	HideQuestText(playerid);
	return 1;
}

SCM(playerid, color, text[]) return SendClientMessage(playerid, color, text);

SetPlayerMoney(playerid, geld)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, geld);
	return 1;
}

ShowLagerDialog(playerid)
{
    new dialogText[256];
	format(dialogText, sizeof(dialogText), "{FFFFFF}Aktueller Inhalt des Questlagers\n \nFische einlagern\nPilze einlagern\nEdelsteine einlagern\n \nKapazität ausbauen\nSicherheit ausbauen");

	ShowPlayerDialog(playerid, DIALOG_QUEST_LAGER, DIALOG_STYLE_LIST, "{FFFF00}Lager für Questobjekte", dialogText, "Auswählen", "Schließen");
	return 1;
}

ShowQuestText(playerid)
{
	// Alle TextDraws anzeigen lassen
	PlayerTextDrawShow(playerid, questTD[playerid]);
	PlayerTextDrawShow(playerid, questTDHead[playerid]);
	PlayerTextDrawShow(playerid, questTDInfo[playerid]);
	PlayerTextDrawShow(playerid, questTDTime[playerid]);
	return 1;
}

UpdateQuestHeading(playerid, text[])
{
	PlayerTextDrawSetString(playerid, questTDHead[playerid], text);
	return 1;
}

UpdateQuestText(playerid, text[])
{
	PlayerTextDrawSetString(playerid, questTD[playerid], "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	PlayerTextDrawSetString(playerid, questTDInfo[playerid], text);
	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
	return 1;
}

UpdateQuestTime(playerid, time)
{
    new questMin, questSek, timeStr[128];
	questSek = time % 60;
	questMin = (time - questSek) / 60;
	format(timeStr, sizeof(timeStr), "Verbleibene Zeit: %02d:%02d", questMin, questSek);
	
	PlayerTextDrawSetString(playerid, questTDTime[playerid], timeStr);
	return 1;
}

// made by Kaliber
stock split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}
