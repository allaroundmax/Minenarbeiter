// Includes
#include <a_mysql>
#include <a_samp>
#include <ocmd>
#include <sscanf2>

// Farbendefinierung
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

// Definierungen
#define BEZIRK_EASTLS 0
#define BEZIRK_REDCOUNTY 1

#define CP_PIZZA_END 3001
#define CP_PIZZA_TRUNK 3002

#define END_PIZZA_EASTLS

#define DIALOG_PIZZAJOB 4001
#define MAX_PIZZABOYS 32
#define MAX_PIZZAGESCHAEFTE 2

#define RADAR_PIZZA 60

#undef MAX_PLAYERS
#define MAX_PLAYERS 375

// Enumdefinierung
enum geschaefte
{
	Float:start_x,
	Float:start_y,
	Float:start_z,
	Float:end_x,
	Float:end_y,
	Float:end_z,
	bezirkStr[32],
	orteStr[128]
};

enum jobPoints
{
	Float:j_x,
	Float:j_y,
	Float:j_z
};

enum objects
{
	o_ID,
	o_mID,
	Float:o_x,
	Float:o_y,
	Float:o_z,
	Float:o_rx,
	Float:o_ry,
	Float:o_rz,
	Text3D:o_tID
};

enum jobCars
{
	carID,
	Float:carX,
	Float:carY,
	Float:carZ,
	Float:carAng,
};

enum playerInfo
{
	bool:acceptedJob,
	checkpoint,
	bool:inJob,
	oldCar,
	pizzaAnzahl,
	pizzaBezirk,
	pizzaBoy,
	pizzaCP[30],
	pizzaObject,
	pizzaSkill,
	pizzaTimer,
	pizzaXP
};

// Forwards
forward clearPizzaAnim(playerid);
forward createPizzaObject(playerid);
forward holdPizza(playerid);
forward OnMySQLChecked(playerid);

// Variablendefinierung
// Variable, in der alle Checkpoints (Häuser) gespeichert werden
new cInfo[][][jobPoints] = {
	{   // Alle Häuser aus dem 1. Bezirk
		{2192.605, -1814.494, 13.120},
		{2185.953, -1815.189, 13.118},
		{2176.487, -1814.798, 13.115},
		{2169.012, -1815.226, 13.112},
		{2163.154, -1815.227, 13.111},
		{2155.752, -1815.227, 13.118},
		{2151.759, -1815.227, 13.111},
		{2151.065, -1807.849, 13.112},
		{2151.258, -1789.478, 13.079},
		{2140.928, -1801.772, 16.147},
		{2144.918, -1801.772, 16.140},
		{2146.517, -1808.533, 16.140},
		{2146.473, -1814.858, 16.140},
		{2151.753, -1819.690, 16.140},
		{2158.383, -1819.696, 16.140},
		{2164.661, -1819.696, 16.140},
		{2172.149, -1819.695, 16.140},
		{2176.493, -1821.637, 16.146},
		{2176.491, -1828.439, 16.141},
		{2157.316, -1709.160, 15.085},
		{2140.571, -1708.308, 15.085},
		{2150.869, -1717.905, 15.085},
		{2168.000, -1718.819, 15.166},
		{2166.157, -1671.689, 14.661},
		{2178.201, -1660.331, 14.977},
		{2163.695, -1661.248, 15.085},
		{2151.117, -1672.549, 15.085},
		{2143.595, -1662.928, 15.085},
		{2156.208, -1651.716, 15.078},
		{2141.762, -1652.586, 15.085},
		{2129.119, -1663.938, 15.085},
		{2185.325, -1608.217, 14.359},
		{2191.910, -1592.950, 14.351},
		{2179.210, -1599.480, 14.348},
		{2172.706, -1614.974, 14.296},
		{2159.099, -1577.928, 14.283},
		{2143.535, -1571.292, 14.193},
		{2150.304, -1583.966, 14.336},
		{2165.609, -1590.513, 14.346},
		{2151.572, -1598.472, 14.345},
		{2136.193, -1592.057, 14.351},
		{2142.242, -1604.875, 14.351},
		{2158.067, -1611.284, 14.350},
		{2067.698, -1628.795, 14.206},
		{2067.562, -1643.571, 14.136},
		{2066.839, -1656.421, 14.132},
		{2065.102, -1703.621, 14.148},
		{2066.242, -1717.157, 14.136},
		{2067.052, -1731.797, 14.206},
		{2015.196, -1733.109, 14.234},
		{2016.201, -1716.895, 14.125},
		{2017.980, -1703.552, 14.234},
		{2013.578, -1656.449, 14.136},
		{2013.578, -1656.449, 14.136},
		{2017.736, -1629.987, 13.712},
		{2011.340, -1594.404, 13.583},
		{2002.488, -1593.930, 13.577},
		{1986.401, -1605.299, 13.532},
		{1972.707, -1560.141, 13.639},
		{1958.682, -1560.578, 13.594},
		{1967.249, -1633.707, 18.568},
		{1972.069, -1633.707, 18.568},
		{1976.214, -1634.130, 18.568},
		{1967.054, -1633.932, 15.968},
		{1972.076, -1633.708, 15.968},
		{1976.214, -1633.886, 16.211},
		{1969.329, -1654.778, 15.968},
		{1973.303, -1654.666, 15.968},
		{1969.786, -1671.192, 18.545},
		{1974.591, -1671.191, 18.545},
		{1978.768, -1671.262, 18.545},
		{1969.879, -1671.192, 15.968},
		{1974.613, -1671.353, 15.968},
		{1978.752, -1671.414, 16.187},
		{1980.992, -1682.837, 17.053},
		{1969.978, -1678.813, 17.080},
		{1973.372, -1705.143, 15.968},
		{1969.424, -1705.142, 15.968},
		{1969.254, -1714.891, 17.055},
		{1980.375, -1719.050, 17.030},
		{2256.902, -1644.630, 15.088},
		{2244.227, -1638.411, 15.477},
		{2282.165, -1641.598, 15.889},
		{2307.021, -1678.091, 14.001},
		{2328.524, -1681.868, 14.821},
		{2326.836, -1717.165, 13.907},
		{2308.855, -1715.017, 14.649},
		{2385.644, -1713.106, 14.162},
		{2402.524, -1715.700, 14.121},
		{2368.261, -1674.832, 14.168},
		{2362.845, -1643.986, 13.533},
		{2393.176, -1646.694, 13.643},
		{2384.690, -1675.719, 15.245},
		{2409.012, -1674.179, 13.605},
		{2393.196, -1646.305, 13.905},
		{2413.782, -1646.786, 14.011},
		{2451.861, -1641.760, 13.735},
		{2321.981, -1796.045, 13.546},
		{2344.827, -1785.677, 13.546},
		{2380.056, -1785.569, 13.112},
		{2360.475, -1796.078, 13.120},
		{2307.056, -1785.622, 13.127},
		{2290.398, -1796.107, 13.116},
		{2247.467, -1796.068, 13.111},
		{2275.258, -1785.917, 13.109},
		{2395.528, -1795.740, 13.109},
		{2438.123, -2020.098, 13.347},
		{2464.884, -1996.444, 13.443},
		{2465.324, -2020.726, 14.124},
		{2486.611, -2021.307, 13.568},
		{2507.985, -2020.649, 14.210},
		{2522.776, -2018.975, 14.074},
		{2524.350, -1998.380, 14.113},
		{2508.270, -1998.448, 13.902},
		{2696.361, -1990.709, 14.222},
		{2672.679, -1989.471, 14.324},
		{2652.893, -1989.650, 13.998},
		{2637.054, -1991.763, 14.324},
		{2635.671, -2012.851, 14.144},
		{2650.302, -2021.783, 14.176},
		{2673.278, -2020.106, 14.168},
		{2695.353, -2020.377, 14.022},
		{2263.904, -1469.408, 24.370},
		{2247.685, -1469.592, 24.149},
		{2232.529, -1469.520, 24.251},
		{2190.615, -1470.450, 25.914},
		{2191.485, -1455.929, 25.851},
		{2194.590, -1443.025, 25.743},
		{2196.777, -1404.158, 25.382},
		{2189.660, -1418.898, 25.693},
		{2230.479, -1397.210, 24.573},
		{2243.559, -1397.123, 24.573},
		{2256.469, -1397.150, 24.573},
		{2185.088, -1363.905, 25.829},
		{2202.719, -1363.979, 25.860},
		{2150.990, -1400.616, 25.798},
		{2150.789, -1419.060, 25.921},
		{2149.714, -1433.720, 26.070},
		{2152.216, -1446.360, 26.105},
		{2146.797, -1470.391, 26.042},
		{2148.578, -1484.793, 26.624},
		{2129.618, -1361.738, 26.136},
		{2147.635, -1366.302, 25.641},
		{2091.200, -1278.430, 25.710},
		{2111.195, -1279.640, 25.256},
		{2100.913, -1321.572, 25.524},
		{2132.082, -1280.185, 25.461},
		{2126.678, -1320.611, 26.624},
		{2148.489, -1319.318, 25.313},
		{2150.020, -1285.796, 23.941},
		{2191.519, -1276.286, 25.156},
		{2153.838, -1243.253, 24.939},
		{2133.392, -1232.753, 24.421},
		{2110.962, -1244.163, 25.421},
		{2191.863, -1238.527, 23.759},
		{2209.855, -1239.330, 23.722},
		{2229.508, -1239.945, 25.121},
		{2249.835, -1238.782, 25.463},
		{2110.944, -1244.064, 25.851},
		{2090.667, -1234.889, 25.688},
		{2334.634, -1203.996, 27.976},
		{2334.813, -1266.091, 27.539},
		{2324.493, -1249.756, 27.547},
		{2324.468, -1281.225, 27.551},
		{2388.142, -1279.558, 25.129},
		{2387.510, -1328.378, 25.124},
		{2389.649, -1346.041, 25.076},
		{2383.351, -1366.252, 24.491},
		{2433.692, -1275.004, 24.756},
		{2434.879, -1289.313, 25.347},
		{2434.147, -1303.385, 24.991},
		{2434.059, -1320.740, 24.980},
		{2439.739, -1338.868, 24.101},
		{2439.751, -1357.146, 24.100},
		{2424.822, -1355.109, 24.324},
		{2424.826, -1336.793, 24.324},
		{2470.372, -1295.472, 30.233},
		{2469.097, -1278.278, 30.366},
		{2472.879, -1238.268, 32.569},
		{2492.075, -1239.011, 37.905},
		{2536.933, -1235.482, 43.656},
		{2550.927, -1234.215, 49.001},
		{2587.153, -1200.120, 59.218},
		{2587.292, -1203.060, 58.576},
		{2587.077, -1207.666, 57.507},
		{2587.070, -1211.777, 56.375},
		{2587.131, -1216.430, 54.976},
		{2587.103, -1220.558, 53.679},
		{2587.109, -1224.712, 52.399},
		{2587.182, -1229.231, 51.045},
		{2587.091, -1233.502, 49.820},
		{2587.224, -1238.060, 48.564},
		{2550.215, -1197.247, 60.824},
		{2520.722, -1197.765, 56.583},
		{2594.761, -1200.019, 59.218},
		{2594.611, -1207.599, 57.651},
		{2594.498, -1216.308, 55.114},
		{2594.497, -1224.710, 52.477},
		{2594.562, -1233.558, 49.962},
		{2594.900, -1237.964, 48.421},
		{2600.889, -1238.015, 48.681},
		{2601.050, -1229.249, 51.342},
		{2600.950, -1220.543, 53.900},
		{2601.025, -1211.776, 56.654},
		{2601.039, -1203.064, 58.725},
		{2608.328, -1203.095, 60.000},
		{2608.366, -1211.734, 57.937},
		{2608.519, -1220.505, 55.187},
		{2608.269, -1229.192, 52.857},
		{2608.425, -1237.937, 49.984},
		{2614.973, -1233.374, 51.382},
		{2614.986, -1224.761, 53.898},
		{2614.713, -1216.200, 56.539},
		{2614.874, -1207.563, 59.070},
		{2614.817, -1200.117, 60.781},
		{2622.456, -1203.084, 61.070},
		{2622.538, -1211.809, 59.000},
		{2622.253, -1220.499, 56.481},
		{2622.721, -1229.120, 53.679},
		{2622.812, -1238.163, 51.061},
		{2662.669, -1200.131, 66.323},
		{2662.354, -1211.897, 63.484},
		{2663.005, -1224.738, 59.586},
		{2662.646, -1237.994, 55.565},
		{2670.500, -1238.105, 55.729},
		{2670.762, -1224.759, 59.638},
		{2670.575, -1207.579, 64.809},
		{2683.439, -1200.093, 66.806},
		{2683.427, -1211.764, 63.961},
		{2683.154, -1216.352, 62.482},
		{2683.252, -1233.573, 57.377},
		{2683.216, -1200.125, 66.719},
		{2682.940, -1220.359, 61.128},
		{2683.310, -1229.268, 58.619},
		{2670.589, -1233.520, 57.127},
		{2670.574, -1220.489, 60.929},
		{2670.279, -1203.039, 65.728},
		{2699.923, -1200.058, 68.825},
		{2700.206, -1211.771, 66.128},
		{2700.069, -1224.706, 62.067},
		{2690.852, -1233.515, 58.891},
		{2690.990, -1220.531, 62.696},
		{2690.774, -1203.117, 67.489},
		{2708.098, -1203.051, 69.554},
		{2707.720, -1207.668, 68.632},
		{2707.600, -1224.695, 63.453},
		{2707.597, -1237.923, 59.546},
		{2756.348, -1182.666, 69.400},
		{2749.948, -1205.672, 67.484},
		{2750.197, -1222.208, 64.601},
		{2749.940, -1238.656, 61.524},
		{2852.938, -1366.019, 14.164},
		{2847.297, -1309.821, 14.690},
		{2807.825, -1176.598, 24.959},
		{2808.046, -1189.905, 24.916},
		{2628.433, -1067.889, 69.612},
		{2627.964, -1085.181, 69.616},
		{2626.408, -1098.765, 69.355},
		{2626.181, -1112.608, 67.855},
		{2576.359, -1070.697, 69.832},
		{2572.037, -1091.478, 67.225},
		{2519.428, -1113.080, 56.592},
		{2470.613, -1105.010, 44.157},
		{2457.013, -1102.203, 43.867},
		{2438.635, -1105.233, 42.751},
		{2407.889, -1106.686, 40.295},
		{2526.578, -1060.674, 69.770},
		{2534.050, -1063.462, 69.565},
		{2499.269, -1065.535, 70.132},
		{2479.552, -1063.917, 66.998},
		{2457.649, -1054.639, 59.959},
		{2440.596, -1056.907, 54.738},
		{2389.635, -1037.394, 53.559},
		{2370.255, -1035.221, 54.410},
		{2335.035, -1045.606, 52.358},
		{2297.593, -1053.138, 49.933},
		{2283.962, -1046.443, 49.887},
		{2249.762, -1059.894, 55.968},
		{2259.802, -1019.443, 59.294},
		{2218.923, -1031.613, 60.097},
		{2208.108, -1026.487, 61.246},
		{2186.436, -997.690, 66.468},
		{2139.901, -1008.284, 61.811},
		{2108.961, -1000.494, 60.507},
		{2051.069, -954.655, 48.034},
		{1955.637, -1115.363, 27.830},
		{1939.066, -1114.482, 27.452},
		{1921.654, -1115.223, 27.088},
		{1905.967, -1112.944, 26.664},
		{1886.476, -1113.676, 26.275},
		{2022.840, -1120.263, 26.421},
		{2045.535, -1115.802, 26.361},
		{2094.000, -1123.337, 27.689},
		{2092.243, -1166.492, 26.585},
		{2095.361, -1145.110, 26.592},
		{2075.243, -1081.930, 25.634},
		{2061.038, -1075.378, 25.655},
		{2051.060, -1065.974, 25.783},
		{2036.430, -1059.526, 25.650},
		{2023.405, -1053.139, 25.596},
		{2207.711, -1100.717, 31.554},
		{2189.047, -1081.765, 43.831},
		{0.0, 0.0, 0.0}
	},
	
	// Alle Häuser außerhalb von LS (Palo, Blueberry, Montgomery, Dillimore)
	{
	    {745.213, -590.920, 18.244},
		{745.607, -570.212, 18.160},
		{745.158, -556.274, 18.155},
		{736.617, -556.450, 18.159},
		{743.430, -509.814, 18.154},
		{766.608, -556.416, 18.452},
		{768.173, -504.021, 18.300},
		{776.122, -503.787, 18.152},
		{794.777, -506.564, 18.156},
		{818.313, -509.791, 18.156},
		{312.721, -121.280, 4.135},
		{313.025, -92.212, 4.135},
		{300.621, -47.260, 3.377},
		{295.227, -54.543, 3.377},
		{271.605, -48.751, 3.377},
		{248.273, -33.004, 1.722},
		{252.952, -22.541, 1.768},
		{286.085, 41.155, 3.148},
		{308.990, 44.358, 3.687},
		{317.728, 54.595, 3.975},
		{342.545, 62.826, 4.462},
		{339.996, 33.687, 7.008},
		{316.511, 18.255, 5.115},
		{201.485, -94.973, 2.154},
		{166.407, -94.973, 2.154},
		{158.632, -102.613, 2.156},
		{158.633, -112.567, 2.156},
		{166.408, -120.234, 2.154},
		{178.287, -120.234, 2.149},
		{189.382, -120.234, 2.148},
		{201.283, -120.234, 2.151},
		{209.085, -112.540, 2.150},
		{209.085, -102.724, 2.158},
		{160.634, -112.625, 5.496},
		{166.254, -118.234, 5.496},
		{177.989, -118.159, 5.496},
		{160.633, -102.597, 5.496},
		{166.229, -96.972, 5.496},
		{178.370, -96.971, 5.496},
		{201.254, -96.977, 5.496},
		{189.401, -96.971, 5.496},
		{207.076, -112.169, 5.496},
		{201.480, -118.234, 5.496},
		{252.888, -92.327, 4.135},
		{252.888, -121.317, 4.135},
		{870.419, -25.443, 64.094},
		{2363.503, 187.254, 28.585},
		{2323.846, 191.058, 28.585},
		{2323.846, 162.193, 28.585},
		{2363.844, 166.287, 28.585},
		{2363.997, 142.117, 28.585},
		{2323.846, 136.434, 28.585},
		{2323.846, 116.014, 28.585},
		{2363.997, 116.267, 28.585},
		{2285.824, 161.770, 28.585},
		{2266.454, 168.339, 28.753},
		{2257.929, 168.339, 28.753},
		{2236.313, 167.916, 28.753},
		{2269.586, 111.276, 28.586},
		{2249.346, 111.771, 28.585},
		{2203.846, 106.146, 28.585},
		{2203.847, 62.265, 28.585},
		{2398.262, 111.263, 28.582},
		{2374.330, 71.248, 28.586},
		{2374.340, 42.176, 28.584},
		{2374.342, 22.123, 28.585},
		{2374.343, -8.888, 28.585},
		{2366.983, -48.567, 28.753},
		{2383.855, -54.454, 28.296},
		{2392.400, -54.543, 28.295},
		{2415.228, -51.754, 28.295},
		{2438.661, -54.460, 28.300},
		{2410.946, -5.530, 27.823},
		{2416.535, 17.838, 27.792},
		{2410.993, 22.126, 27.825},
		{2413.548, 61.278, 28.586},
		{2443.285, 61.294, 28.586},
		{2439.639, 24.983, 27.789},
		{2448.516, -11.019, 28.283},
		{2443.316, 61.763, 28.585},
		{2413.566, 61.763, 28.585},
		{2443.846, 92.260, 28.441},
		{2462.697, 134.436, 28.189},
		{2479.343, 94.799, 27.827},
		{2480.818, 126.764, 27.820},
		{2518.569, 128.613, 27.820},
		{2510.233, 88.975, 28.081},
		{2536.090, 128.727, 27.825},
		{2551.033, 92.189, 27.817},
		{2556.583, 87.901, 28.010},
		{2550.809, 57.235, 27.819},
		{2511.595, 57.217, 28.283},
		{2549.008, 24.852, 27.813},
		{2551.018, -5.385, 27.822},
		{2513.405, -27.897, 28.587},
		{2484.522, -28.403, 29.041},
		{2488.447, 11.763, 29.041},
		{2509.385, 11.763, 29.041},
		{2322.177, -124.474, 28.302},
		{2314.244, -124.646, 28.297},
		{2293.891, -124.453, 28.296},
		{2272.303, -118.642, 28.298},
		{2245.909, -121.924, 28.297},
		{2203.650, -89.135, 28.288},
		{2197.765, -60.590, 28.298},
		{2200.314, -37.028, 28.425},
		{2245.680, -2.121, 28.507},
		{2270.605, -8.031, 28.273},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0}
	}
};

new dbHandle;

// Array für die Start & End Punkte
new gInfo[MAX_PIZZAGESCHAEFTE][geschaefte] = {
	{2105.056, -1793.251, 13.554, 2116.870, -1762.230, 13.398, "East Los Santos", "Idlewood, Ganton, Willowfield, Jefferson, uvm."},
	{2333.537, 78.774, 26.620, 2321.205, 79.760, 26.483, "Außenviertel von Los Santos", "Palomino Creek, Blueberry, Dillimore, uvm."}
};

// Alle Pizza-Objekte (an dem Geschäft bei /pizza)
new oInfo[MAX_PIZZAGESCHAEFTE][objects] = {
	{0, 2646, 2105.356, -1793.187, 14.154, 0.0, 0.0, -90.0},
	{0, 2646, 2333.208, 78.831, 27.13, 0.0, 0.0, 90.0}
};

// Spielerinfos
new pInfo[MAX_PLAYERS][playerInfo];

// Alle Pizzaboys
new pizzaBoys[MAX_PIZZABOYS][jobCars] = {
	// Idlewood
	{0, 2122.190, -1784.381, 12.986, 5.101},
	{0, 2119.410, -1784.381, 12.986, 5.101},
	{0, 2116.630, -1784.381, 12.986, 5.101},
	{0, 2113.850, -1784.381, 12.986, 5.101},
	{0, 2111.070, -1784.381, 12.986, 5.101},
	{0, 2108.290, -1784.381, 12.986, 5.101},
	{0, 2105.510, -1784.381, 12.986, 5.101},
	{0, 2102.730, -1784.381, 12.986, 5.101},
	{0, 2099.653, -1784.559, 12.986, 314.572},
	{0, 2100.051, -1781.997, 12.986, 271.596},
	{0, 2100.451, -1779.497, 12.986, 271.596},
	{0, 2100.851, -1776.997, 12.986, 271.596},
	{0, 2101.151, -1774.497, 12.986, 271.596},
	{0, 2101.501, -1771.997, 12.986, 271.596},
	{0, 2103.006, -1769.635, 12.986, 225.506},
	{0, 2105.145, -1768.654, 12.986, 181.006},
	
	// Palomino Creek
	{0, 2318.759, 75.392, 26.038, 224.187},
	{0, 2324.283, 76.064, 26.086, 142.216},
	{0, 2323.817, 73.619, 26.082, 92.808},
	{0, 2324.024, 71.276, 26.084, 92.863},
	{0, 2323.844, 67.580, 26.084, 29.479},
	{0, 2315.283, 66.352, 26.080, 273.295},
	{0, 2315.029, 68.551, 26.082, 270.781},
	{0, 2315.627, 62.763, 26.079, 359.397},
	{0, 2317.709, 63.305, 26.083, 0.586},
	{0, 2323.270, 63.271, 26.087, 90.589},
	{0, 2323.528, 59.991, 26.086, 89.066},
	{0, 2325.802, 61.569, 26.087, 88.644},
	{0, 2316.330, 58.352, 26.081, 248.789},
	{0, 2315.364, 57.310, 26.081, 274.371},
	{0, 2315.350, 55.589, 26.081, 270.189},
	{0, 2316.334, 53.532, 26.080, 279.600}
};

// Chat-Clearen (für Aufnahmen)
ocmd:cc(playerid)
{
	for(new i = 0; i < 15; i++) SCM(playerid, COLOR_BLACK, " ");
	return 1;
}

// Zu den Pizza-Dingern teleportieren
ocmd:gotopizza(playerid, params[])
{
	new pizzaLaden;
	if(sscanf(params, "i", pizzaLaden)) return SCM(playerid, COLOR_GREY, "Verwendung: /gotopizza [ID]");
	
	if(pizzaLaden == 1) SetPlayerPos(playerid, 2098.366, -1804.953, 13.554);
	else if(pizzaLaden == 2) SetPlayerPos(playerid, 2333.553, 78.849, 26.620);
	else SCM(playerid, COLOR_RED, "Diese ID existiert nicht!");
	
	return 1;
}

// Hauptbefehl für den Pizza-Job
ocmd:pizza(playerid, params[])
{
	new str[16];
	if(sscanf(params, "s[16]", str)) return SCM(playerid, COLOR_GREY, "Verwendung: /pizza [abort / help / start / stats]");
	
	// Pizza-Auftrag abbrechen
	if(!strcmp(str, "abort", true))
	{
	    // Falls der Spieler keinen Auftrag angenommen hat
	    if(!pInfo[playerid][acceptedJob]) return SCM(playerid, COLOR_RED, "Du hast noch keinen Pizza-Auftrag angenommen!");

		// Map-Icons löschen lassen
		for(new i = 0; i < 8 + pInfo[playerid][pizzaSkill] * 2; i++) RemovePlayerMapIcon(playerid, RADAR_PIZZA + i);

		// Spieler aus dem Pizzaboy kicken, falls er auf einem sitzt
		new vID = GetPlayerVehicleID(playerid);
		new mID = GetVehicleModel(vID);
		if(mID == 448) RemovePlayerFromVehicle(playerid);
		
		// PizzaBoy respawnen
		SetVehicleToRespawn(pInfo[playerid][pizzaBoy]);

		pInfo[playerid][acceptedJob] = false;
		pInfo[playerid][inJob] = false;
		pInfo[playerid][pizzaBoy] = false;
		
		// Timer löschen, der die Halteposition setzt
		KillTimer(pInfo[playerid][pizzaTimer]);

		// Pizza ablegen und löschen
		DestroyObject(pInfo[playerid][pizzaObject]);
		pInfo[playerid][pizzaObject] = 0;

		ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);

		SCM(playerid, COLOR_GREEN, "Du hast den aktellen Lieferauftrag abgebrochen!");
	}
	
	// Pizza-Job Starten
	else if(!strcmp(str, "start", true))
	{
		// Falls der Spieler schon einen Auftrag hat
	    if(pInfo[playerid][acceptedJob] || pInfo[playerid][inJob]) return SCM(playerid, COLOR_RED, "Du hast bereits einen Lieferauftrag angenommen! Abbrechen mit \"/pizza abort\"!");

		for(new i = 0; i < MAX_PIZZAGESCHAEFTE; i++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 4, gInfo[i][start_x], gInfo[i][start_y], gInfo[i][start_z]))
		    {
		        if(pInfo[playerid][pizzaSkill] < i + 1)
				{
				    new msg[128];
				    format(msg, sizeof(msg), "Dein Skilllevel ist nicht hoch genug, um in diesem Bezirk zu arbeiten! (Benötigter Skill: %i)", i + 1);
				    return SCM(playerid, COLOR_RED, msg);
				}
		        pInfo[playerid][pizzaBezirk] = i;
		        
		        new dialogHeading[128], dialogDescription[1024];
				format(dialogHeading, sizeof(dialogHeading), "{33CCFF}Job: {FFFFFF}Pizzalieferrant - {33CCFF}Bezirk #%i: {FFFFFF}%s", i + 1, gInfo[i][bezirkStr]);
				format(dialogDescription, sizeof(dialogDescription), "{FFFFFF}Dir werden {33CCFF}%i Häuser {FFFFFF}auf der Karte markiert, welche du mit deinem {33CCFF}Pizzaboy {FFFFFF}abfahren musst.\nDort kannst du die {33CCFF}Pizzen abliefern{FFFFFF}, die du davor vom {33CCFF}Pizzaboy {FFFFFF}holen musst.\n\n{33CCFF}Folgende Bezirke wirst du abfahren:\n{FFFFFF}%s", 8 + pInfo[playerid][pizzaSkill] * 2, gInfo[i][orteStr]);

				return ShowPlayerDialog(playerid, DIALOG_PIZZAJOB, DIALOG_STYLE_MSGBOX, dialogHeading, dialogDescription, "{FFFFFF}Annehmen", "{FFFFFF}Ablehnen");
		    }
		}
		return SCM(playerid, COLOR_RED, "Du bist nicht in der Nähe eines Pizzaladens!");
	}
	
	// Pizza-Stats
	else if(!strcmp(str, "stats", true))
	{
		new msg[128];
		format(msg, sizeof(msg), "Aktuelles Skilllevel: %i (%i/%i XP)", pInfo[playerid][pizzaSkill], pInfo[playerid][pizzaXP], 15 + pInfo[playerid][pizzaSkill] * 15);
		SCM(playerid, COLOR_ORANGE, msg);
	 	return 1;
	}
	
	// Wenn nichts gefunden wurde
	else SCM(playerid, COLOR_GREY, "Verwendung: /pizza [abort / help / start / stats]");
	return 1;
}

// Position auslesen (zum Testen)
ocmd:pizzapos(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	
	new msg[64];
	format(msg, sizeof(msg), "%.3f, %.3f, %.3f", x, y, z);
	SCM(playerid, COLOR_YELLOW, msg);
	return 1;
}

// Jobfahrzeuge respawnen
ocmd:respawnpizzaboys(playerid)
{
	for(new i = 0; i < MAX_PIZZABOYS; i++) if(!IsSomebodyInVehicle(pizzaBoys[i][carID])) SetVehicleToRespawn(pizzaBoys[i][carID]);
	SCM(playerid, COLOR_GREEN, "Du hast alle Pizzaboys respawnt!");
	return 1;
}

// Pizza-Skill setzen (zum Testen)
ocmd:setpizzaskill(playerid, params[])
{
	new name[MAX_PLAYER_NAME], pID, skill, msg[128];
	if(sscanf(params, "ii", pID, skill)) return SCM(playerid, COLOR_GREY, "Verwendung: /setpizzaskill [ID] [Skill]");
	
	if(skill < 1) return SCM(playerid, COLOR_RED, "Das Skilllevel darf nicht unter 1 liegen!");

	pInfo[pID][pizzaSkill] = skill;

    GetPlayerName(playerid, name, sizeof(name));
	format(msg, sizeof(msg), "%s hat deinen Pizza-Skill auf %i gesetzt.", name, skill);
	SCM(pID, COLOR_GREEN, msg);

	GetPlayerName(pID, name, sizeof(name));
	format(msg, sizeof(msg), "Du hast den Pizza-Skill von %s auf %i gesetzt.", name, skill);
	SCM(playerid, COLOR_GREEN, msg);

	// In die Datenbank schreiben
	new query[128];
	format(query, sizeof(query), "UPDATE pizza SET skill = '%i' WHERE username = '%s'", skill, name);
	mysql_function_query(dbHandle, query, false, "", "");
	return 1;
}

// Pizza-XP setzen (zum Testen)
ocmd:setpizzaxp(playerid, params[])
{
	new name[MAX_PLAYER_NAME], pID, xp, msg[128];
	if(sscanf(params, "ii", pID, xp)) return SCM(playerid, COLOR_GREY, "Verwendung: /setpizzaxp [ID] [XP]");

	if(xp < 0) return SCM(playerid, COLOR_RED, "Die XP darf nicht unter 0 liegen!");

	pInfo[pID][pizzaXP] = xp;

    GetPlayerName(playerid, name, sizeof(name));
	format(msg, sizeof(msg), "%s hat deine Pizza-XP auf %i gesetzt.", name, xp);
	SCM(pID, COLOR_GREEN, msg);

	GetPlayerName(pID, name, sizeof(name));
	format(msg, sizeof(msg), "Du hast diee Pizza-XP von %s auf %i gesetzt.", name, xp);
	SCM(playerid, COLOR_GREEN, msg);

	// In die Datenbank schreiben
	new query[128];
	format(query, sizeof(query), "UPDATE pizza SET xp = '%i' WHERE username = '%s'", xp, name);
	mysql_function_query(dbHandle, query, false, "", "");
	return 1;
}

public createPizzaObject(playerid)
{
	// Objekt erstellen und am Spieler anbringen
	pInfo[playerid][pizzaObject] = CreateObject(2814, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	AttachObjectToPlayer(pInfo[playerid][pizzaObject], playerid, 0.0, 0.4, 0.3, 0.0, 0.0, 90.0);
	
	// Timer starten, der die "Halteanimation" immer wiederholt
	pInfo[playerid][pizzaTimer] = SetTimerEx("holdPizza", 100, true, "i", playerid);
	return 1;
}

public holdPizza(playerid)
{
	// Objekt & Timer löschen, falls Spieler im Fahrzeug sitzt
	if(IsPlayerInAnyVehicle(playerid))
	{
	    DestroyObject(pInfo[playerid][pizzaObject]);
	    pInfo[playerid][pizzaObject] = 0;
	    
	    KillTimer(pInfo[playerid][pizzaTimer]);
	    return 1;
	}
	
	// Falls der Spieler eine Waffe trägt
	SetPlayerArmedWeapon(playerid, 0);
	
	// Checkt, ob der Spieler in einem Checkpoint steht
	new pointID = GetPlayerJobCheckpoint(playerid);
	if(pointID != -1)
	{
		// Pizza abgeben
		RemovePlayerMapIcon(playerid, RADAR_PIZZA + pointID);
		pInfo[playerid][pizzaAnzahl]--;
		pInfo[playerid][pizzaCP][pointID] = 302;

		// Falls alle Pizzen abgegeben wurden
		if(pInfo[playerid][pizzaAnzahl] == 0)
		{
		    new bezirk = pInfo[playerid][pizzaBezirk];
		    SetPlayerCheckpoint(playerid, gInfo[bezirk][end_x], gInfo[bezirk][end_y], gInfo[bezirk][end_z], 4);

			PlayerPlaySound(playerid, 1137, 0.0, 0.0, 3.0);
		    SCM(playerid, COLOR_LIGHTBLUE, "Du hast alle Pizzen abgegeben! Kehre zurück zum Pizzageschäft um deinen Lohn zu erhalten!");
		    pInfo[playerid][checkpoint] = CP_PIZZA_END;
		}
		else
		{
		    new msg[128];
		    new trinkgeld = random(100);

			// 1/4 Chance für Trinkgeld
		    if(trinkgeld < 25 + pInfo[playerid][pizzaSkill] * 2.5)
			{
			    new tGeld = random(75 + pInfo[playerid][pizzaSkill] * 50) + 1;
			    format(msg, sizeof(msg), "Du hast die Pizza abgegeben und %i$ Trinkgeld erhalten! Verbleibene Pizzen: %i", tGeld, pInfo[playerid][pizzaAnzahl]);
			    GivePlayerMoney(playerid, tGeld);
			    
			    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 5.0);
			    SCM(playerid, COLOR_YELLOW, msg);
			}
		    else
			{
				format(msg, sizeof(msg), "Du hast die Pizza abgegeben! Verbleibene Pizzen: %i", pInfo[playerid][pizzaAnzahl]);
			    SCM(playerid, COLOR_GREEN, msg);
			    
			    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 4.0);
			    
			    new bezirk = pInfo[playerid][pizzaBezirk];
			    new id;
			    for(new i = 0; i < 8 + pInfo[playerid][pizzaSkill] * 2; i++)
			    {
			        id = pInfo[playerid][pizzaCP][i];
			        if(GetVehicleDistanceFromPoint(pInfo[playerid][pizzaBoy], cInfo[bezirk][id][j_x], cInfo[bezirk][id][j_y], cInfo[bezirk][id][j_z]) < 25)
			        {
                        new Float:t_x, Float:t_y, Float:t_z;
						GetVehicleTrunkPos(pInfo[playerid][pizzaBoy], t_x, t_y, t_z);

						SetPlayerCheckpoint(playerid, t_x, t_y, t_z, 1);
						pInfo[playerid][checkpoint] = CP_PIZZA_TRUNK;
						break;
			        }
			    }
			}
		}

		// Timer löschen, der die Halteposition setzt
		KillTimer(pInfo[playerid][pizzaTimer]);

		// Pizza ablegen und löschen
		DestroyObject(pInfo[playerid][pizzaObject]);
		pInfo[playerid][pizzaObject] = 0;
		
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
		return 1;
	}
	else
	{
		// Halteanimation setzen
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}

public OnFilterScriptInit()
{
	// Pizza-Boys laden
	for(new i = 0; i < MAX_PIZZABOYS; i++) pizzaBoys[i][carID] = AddStaticVehicleEx(448, pizzaBoys[i][carX], pizzaBoys[i][carY], pizzaBoys[i][carZ], pizzaBoys[i][carAng], 3, 6, 222, 0);
	
	// Objekte erstellen
	for(new i = 0; i < MAX_PIZZAGESCHAEFTE; i++)
	{
		oInfo[i][o_ID] = CreateObject(oInfo[i][o_mID], oInfo[i][o_x], oInfo[i][o_y], oInfo[i][o_z], oInfo[i][o_rx], oInfo[i][o_ry], oInfo[i][o_rz]);
		oInfo[i][o_tID] = Create3DTextLabel("Pizzalieferrant\n{FFFFFF}/pizza start", COLOR_LIGHTBLUE, oInfo[i][o_x], oInfo[i][o_y], oInfo[i][o_z] - 0.3, 11.11, 0, 1);
	}
	
	// Datenbank laden
	dbHandle = mysql_connect("192.168.178.58", "samp", "samp", "123456789");
	
	// Datenbank aller Spieler laden
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    LoadPlayerDatabase(i);
	}
	
	// Filterscript erfolgreich geladen
	SendClientMessageToAll(COLOR_YELLOW, "Pizzalieferrant-Filterscript wurde erfolgreich geladen.");
	return 1;
}

public OnFilterScriptExit()
{
	// Pizza-Boys löschen
	for(new i = 0; i < MAX_PIZZABOYS; i++) DestroyVehicle(pizzaBoys[i][carID]);
	
	// Objekte löschen
	for(new i = 0; i < MAX_PIZZAGESCHAEFTE; i++)
	{
		DestroyObject(oInfo[i][o_ID]);
		Delete3DTextLabel(oInfo[i][o_tID]);
	}
	
	// MapIcons löschen
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		for(new j = 0; j < 8 + pInfo[i][pizzaSkill] * 2; j++) RemovePlayerMapIcon(i, RADAR_PIZZA + j);
		
		// Pizza-Objekt in der Hand löschen
		if(pInfo[i][pizzaObject]) DestroyObject(pInfo[i][pizzaObject]);
	}
	
	// Datenbank ordentlich schließen
	mysql_close(dbHandle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	// Daten des Spielers laden
    LoadPlayerDatabase(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerPos(playerid, 2098.366, -1804.953, 13.554);
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

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	pInfo[playerid][oldCar] = vehicleid;
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	// Wenn der Spieler in ein Fahrzeug steigt
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
	    // Sollte der Spieler absteigen / vom Pizza-Boy fallen, ohne dass er eine Pizza ausliefern will
	    if(pInfo[playerid][checkpoint] == CP_PIZZA_TRUNK)
	    {
	        DisablePlayerCheckpoint(playerid);
	        pInfo[playerid][checkpoint] = 0;
	    }
	    
	    new vID = GetPlayerVehicleID(playerid);
	    new mID = GetVehicleModel(vID);
	    
	    // Wenn das Fahrzeug ein Pizza-Boy ist
	    if(mID == 448)
	    {
	        // Wenn der Spieler einen Job angenommen hat
		    if(pInfo[playerid][acceptedJob])
		    {
		        // Wenn der Spieler das erste Mal auf einen Pizza-Boy steigt
				if(pInfo[playerid][pizzaBoy] == 0)
				{
				    if(!pInfo[playerid][inJob])
				    {
					    // Job starten
						new bezirk = pInfo[playerid][pizzaBezirk];
						new id;
						new skill = pInfo[playerid][pizzaSkill];

						// Häuser auf der Karte markieren
						for(new i = 0; i < 8 + skill * 2; i++)
						{
						    id = pInfo[playerid][pizzaCP][i];
						    SetPlayerMapIcon(playerid, RADAR_PIZZA + i, cInfo[bezirk][id][j_x], cInfo[bezirk][id][j_y], cInfo[bezirk][id][j_z], 29, 0, MAPICON_GLOBAL_CHECKPOINT);
		  				}

					    pInfo[playerid][inJob] = true;
						pInfo[playerid][pizzaBoy] = vID;
						
						PlayerPlaySound(playerid, 1139, 0.0, 0.0, 5.0);
					    
						SCM(playerid, COLOR_LIGHTBLUE, "Begib dich mit dem Pizza-Boy zu den auf der Karte markieren Häusern!");
						SCM(playerid, COLOR_LIGHTBLUE, "Dort kannst du mit dir eine Pizza vom Pizza-Boy nehmen und abliefern!");
				    }
				}
				else if(vID != pInfo[playerid][pizzaBoy])
				{
				    SCM(playerid, COLOR_RED, "Dies ist nicht dein Pizza-Boy!");
				    RemovePlayerFromVehicle(playerid);
				    return 1;
				}
		    }
			else
			{
				SCM(playerid, COLOR_RED, "Du hast noch keinen Auftrag angenommen!");
				RemovePlayerFromVehicle(playerid);
			}
	    }
	}
	
	// Wenn der Spieler aus einem Fahrzeug steigt
	else if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
	    // Wenn der Spieler von seinem Pizza-Boy steigt
	    if(pInfo[playerid][oldCar] == pInfo[playerid][pizzaBoy])
	    {
	        // Falls der Spieler schon alle Pizzen abgegeben hat
	        if(pInfo[playerid][pizzaAnzahl] == 0) return 1;
	        
	        // Wenn der Spieler zu weit weg steht, wird der Checkpoint nicht angezeigt
	        new bezirk = pInfo[playerid][pizzaBezirk];
		    new id;
		    for(new i = 0; i < 8 + pInfo[playerid][pizzaSkill] * 2; i++)
		    {
		        id = pInfo[playerid][pizzaCP][i];
		        if(GetVehicleDistanceFromPoint(pInfo[playerid][pizzaBoy], cInfo[bezirk][id][j_x], cInfo[bezirk][id][j_y], cInfo[bezirk][id][j_z]) < 25)
		        {
                    new Float:t_x, Float:t_y, Float:t_z;
					GetVehicleTrunkPos(pInfo[playerid][pizzaBoy], t_x, t_y, t_z);

					SetPlayerCheckpoint(playerid, t_x, t_y, t_z, 1);
					pInfo[playerid][checkpoint] = CP_PIZZA_TRUNK;
					break;
		        }
		    }
	    }
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	// Wenn der Spieler in den letzten Checkpoint am Pizzaladen gefahren ist
	if(pInfo[playerid][checkpoint] == CP_PIZZA_END)
	{
	    // Falls der Spieler nicht im Pizza-Boy sitzt
	    if(GetPlayerVehicleID(playerid) != pInfo[playerid][pizzaBoy]) return 1;
	    
	    RemovePlayerFromVehicle(playerid);
	    SetVehicleToRespawn(pInfo[playerid][pizzaBoy]);
	    
	    // Alle Variablen zurücksetzen
	    pInfo[playerid][acceptedJob] = false;
		pInfo[playerid][checkpoint] = false;
		pInfo[playerid][inJob] = false;
		pInfo[playerid][pizzaBoy] = 0;
		DisablePlayerCheckpoint(playerid);
		
		SCM(playerid, COLOR_GREEN, "Du hast alle Pizzen abgeben und den Pizza-Boy zurückgebracht!");
		
		new geld = 4100 + pInfo[playerid][pizzaBezirk] * 1200 + pInfo[playerid][pizzaSkill] * 100, msg[128], xp = random(5 + pInfo[playerid][pizzaSkill]) + 1;
		format(msg, sizeof(msg), "Du erhälst am nächsten Payday %i$ gutgeschrieben. Erhaltene XP: %i", geld, xp);
		GivePlayerMoney(playerid, geld);
		
		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 1.0);
		SCM(playerid, COLOR_GREEN, msg);
		
		// Erfahrungspunkte & Skilllevel
		if(pInfo[playerid][pizzaSkill] < 10) pInfo[playerid][pizzaXP] += xp;
		if(pInfo[playerid][pizzaXP] >= 15 + pInfo[playerid][pizzaSkill] * 15)
		{
		    pInfo[playerid][pizzaSkill]++;
		    pInfo[playerid][pizzaXP] = 0;
			format(msg, sizeof(msg), "Dein Pizza-Skilllevel ist auf Level %i gestiegen!", pInfo[playerid][pizzaSkill]);
			SCM(playerid, COLOR_YELLOW, msg);
		}
		
		// XP und Level in Datenbank speichern
		new name[MAX_PLAYER_NAME], query[128];
		GetPlayerName(playerid, name, sizeof(name));
		format(query, sizeof(query), "UPDATE pizza SET skill = '%i', xp = '%i' WHERE username = '%s'", pInfo[playerid][pizzaSkill], pInfo[playerid][pizzaXP], name);
		mysql_function_query(dbHandle, query, false, "", "");
		
		return 1;
	}
	
	// Wenn der Spieler am Kofferraum eine Pizza rausnimmt
	else if(pInfo[playerid][checkpoint] == CP_PIZZA_TRUNK)
	{
  		new Float:dist, id, bezirk = pInfo[playerid][pizzaBezirk];
		for(new i = 0; i < 8 + pInfo[playerid][pizzaSkill] * 2; i++)
		{
			id = pInfo[playerid][pizzaCP][i];
			dist = GetVehicleDistanceFromPoint(pInfo[playerid][pizzaBoy], cInfo[bezirk][id][j_x], cInfo[bezirk][id][j_y], cInfo[bezirk][id][j_z]);
			
			if(dist < 6)
			{
			    SCM(playerid, COLOR_RED, "Der Pizza-Boy steht zu dicht am Haus!");
			    PlayerPlaySound(playerid, 1053, 0.0, 0.0, 1.0);
				DisablePlayerCheckpoint(playerid);
				pInfo[playerid][checkpoint] = 0;
				return 1;
			}
		}
		
		DisablePlayerCheckpoint(playerid);

		// Spieler holt eine Pizza raus und hält sie in den Händen
		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 1, 1, 0, 0, 1);

		// Timer erstellen, der die Pizza anzeigt und die Animation immer wieder setzt
		SetTimerEx("createPizzaObject", 1200, false, "i", playerid);
	    return 1;
	}
	return 1;
}

public OnPlayerGiveDamage(playerid)
{
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
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_PIZZAJOB)
	{
	    if(response)
		{
	        // Checkpoints für den Spieler generieren
		    GeneratePizzaCheckpoints(playerid, pInfo[playerid][pizzaBezirk]);
		    pInfo[playerid][acceptedJob] = true;
		    
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 1.0);
		    SCM(playerid, COLOR_GREEN, "Du hast deine Aufträge erhalten. Bitte steige auf einen Pizza-Boy, um die Pizzen auszuliefern!");
		    return 1;
		}
	}
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

// Callback der Datenbank
public OnMySQLChecked(playerid)
{
    new num_rows, num_fields;
	cache_get_data(num_rows, num_fields, dbHandle);

	new pName[MAX_PLAYER_NAME], query[128];
 	GetPlayerName(playerid, pName, sizeof(pName));

	// Spieler ist noch nicht in der Datenbank vorhanden
	if(num_rows == 0)
	{
	    format(query, sizeof(query), "INSERT INTO pizza (username, skill) VALUES('%s', '1')", pName);
	    mysql_function_query(dbHandle, query, false, "", "");
	    pInfo[playerid][pizzaSkill] = 1;
	    pInfo[playerid][pizzaXP] = 0;
	}

	// Spieler exisitiert in der Datenbank schon
	else
	{
	    pInfo[playerid][pizzaSkill] = cache_get_field_content_int(0, "skill", dbHandle);
	    pInfo[playerid][pizzaXP] = cache_get_field_content_int(0, "xp", dbHandle);
	}
	return 1;
}

// Pizza-Checkpoints generieren
GeneratePizzaCheckpoints(playerid, id)
{
	new bool:enthalten = false;
	new skill = pInfo[playerid][pizzaSkill];
	
	// Maximale Anzahl der Checkpoints auslesen
	new index = 0, maxCPs;
	while(cInfo[id][index][j_x] != 0.0)
	{
		maxCPs++;
		index++;
	}
	
	// Checkpoints zufällig berechnen lassen
	for(new i = 0; i < 8 + skill * 2; i++)
	{
	    // Damit Checkpoints nicht doppelt enthalten sind
	    enthalten = true;
	    while(enthalten)
	    {
	        // Random einen Punkt auslesen
	        new pointID = random(maxCPs);
			
			// Prüfen, ob der Punkt schon in dem Array vorhanden ist
			for(new j = 0; j < 8 + skill * 2; j++)
			{
			    // Punkt ist noch nicht vorhanden, geht also durch zum nächsten
			    if(pointID != pInfo[playerid][pizzaCP][j])
			    {
			        pInfo[playerid][pizzaCP][i] = pointID;
			        enthalten = false;
			        break;
			    }
			}
	    }
	}
	
	// Variablen setzen
	pInfo[playerid][pizzaAnzahl] = 8 + skill * 2;
	return 1;
}

// Gibt die Point-ID zurück
GetPlayerJobCheckpoint(playerid)
{
	new bezirk = pInfo[playerid][pizzaBezirk];
	new id;

	for(new i = 0; i < 8 + pInfo[playerid][pizzaSkill] * 2; i++)
	{
	    id = pInfo[playerid][pizzaCP][i];
		if(IsPlayerInRangeOfPoint(playerid, 2, cInfo[bezirk][id][j_x], cInfo[bezirk][id][j_y], cInfo[bezirk][id][j_z])) return i;
	}
	return -1;
}

// Gibt die Position des "Kofferraums" zurück
GetVehicleTrunkPos(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset=0.5)
{
    new Float:vehicleSize[3], Float:vehiclePos[3];
    GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehicleSize[0], vehicleSize[1], vehicleSize[2]);
    
    GetXYBehindVehicle(vehicleid, vehiclePos[0], vehiclePos[1], (vehicleSize[1]/2)+offset);
    x = vehiclePos[0];
    y = vehiclePos[1];
    z = vehiclePos[2];
    return 1;
}

// Zwischenfunktion für das obrige
GetXYBehindVehicle(vehicleid, &Float:q, &Float:w, Float:distance)
{
    new Float:a;
    GetVehiclePos(vehicleid, q, w, a);
    GetVehicleZAngle(vehicleid, a);
    q += (distance * -floatsin(-a, degrees));
    w += (distance * -floatcos(-a, degrees));
}

// Checkt, ob jemand einem Fahrzeug sitzt
IsSomebodyInVehicle(vehicleid)
{
	for(new i = 0; i < MAX_PLAYERS; i++) if(GetPlayerVehicleID(i) == vehicleid) return 1;
	return 0;
}

// Datenbank des Spielers laden
LoadPlayerDatabase(playerid)
{
    new pName[MAX_PLAYER_NAME], query[128];
	GetPlayerName(playerid, pName, sizeof(pName));

	format(query, sizeof(query), "SELECT * FROM pizza WHERE username = '%s'", pName);
	mysql_function_query(dbHandle, query, true, "OnMySQLChecked", "i", playerid);
	return 1;
}

// SendClientMessage etwas kürzer ^^
SCM(playerid, color, text[]) return SendClientMessage(playerid, color, text);
