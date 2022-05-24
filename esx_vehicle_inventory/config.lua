--Truck
Config	=	{}

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 0



-- If true, ignore rest of file
Config.WeightSqlBased = false

-- I Prefer to edit weight on the config.lua and I have switched Config.WeightSqlBased to false:

Config.localWeight = {
	bread = 125,
	water = 250,
	alitas = 125,
	bandage = 100,
	bginebra = 250,
	bizcocho = 125,
	bocatajamon = 125,
	bron = 250,
	btequilla = 250,
	bulletproof = 500,
	burger = 125,
	burritos = 125,
	bvodka = 250,
	cafe = 250,
	carokit = 1000,
	cerveza = 250,
	cginebra = 250,
	cheesebows = 125,
	chips = 125,
	cigarett = 100,
	cocacola = 250,
	coctel = 250,
	coke_pooch = 1000,
	condones = 100,
	contrat = 100,
	croquettes = 125,
	ctequila = 250,
	cubata = 250,
	dildo = 100,
	disfrazc = 100,
	disfraze = 100,
	donut = 125,
	drill = 1000,
	durum = 125,
	ensalada = 125,
	esposas = 100,
	fanta = 125,
	firstaidkit = 1000,
	fish = 125,
	fishbait = 100,
	fishingrod = 100,
	gerbera = 100,
	grand_cru = 1000,
	jewels = 100,
	kevlar = 100,
	--lasaña = 125,
	lhierbas = 125,
	lighter = 100,
	loka = 250,
	lubricante = 100,
	macka = 125,
	marabou = 250,
	medikit = 1000,
	meth_pooch = 1000,
	mojito = 250,
	paletillas = 125,
	pastacarbonara = 125,
	pizza = 125,
	quesadillas = 125,
	raisin = 1000,
	satisfyer = 100,
	seed_weed = 100,
	shark = 1000,
	sprite = 250,
	tacos = 250,
	tangac = 100,
	tequila = 250,
	terojo = 250,
	teverde = 250,
	tortilla = 125,
	turtle = 500,
	turtlebait = 100,
	vine = 1000,
	vodka = 250,
	weed_pooch = 1000,
	wood = 250,
	cutted_wood = 200,
	packaged_plank = 2500,
	WEAPON_NIGHTSTICK       = 500,
    WEAPON_STUNGUN          = 1000,
    WEAPON_FLASHLIGHT       = 500,
    WEAPON_FLAREGUN         = 1000,
    WEAPON_FLARE            = 1000,
    WEAPON_COMBATPISTOL     = 2500,
    WEAPON_HEAVYPISTOL      = 4000,
    WEAPON_ASSAULTSMG       = 7000,
    WEAPON_COMBATPDW        = 7000,
    WEAPON_BULLPUPRIFLE     = 8000,
    WEAPON_PUMPSHOTGUN      = 8000,
    WEAPON_BULLPUPSHOTGUN   = 10000,
    WEAPON_CARBINERIFLE     = 10000,
    WEAPON_ADVANCEDRIFLE    = 10000,
    WEAPON_MARKSMANRRIFLE   = 15000,
    WEAPON_SNIPERRIFLE      = 15000,
    WEAPON_FIREEXTINGUISHER = 1500, 
    GADGET_PARACHUTE        = 5000,
    WEAPON_BAT              = 1500,
    WEAPON_PISTOL           = 5000,
    money                   = 6,
	black_money             = 6,
}

Config.VehicleLimit ={
    [0] = 30000, --Compact
    [1] = 40000, --Sedan
    [2] = 100000, --SUV
    [3] = 40000, --Coupes
    [4] = 40000, --Muscle
    [5] = 25000, --Sports Classics
    [6] = 40000, --Sports
    [7] = 5000, --Super
    [8] = 0, --Motorcycles
    [9] = 150000, --Off-road
    [10] = 800000, --Industrial
    [11] = 100000, --Utility
    [12] = 150000, --Vans
    [13] = 0, --Cycles
    [14] = 100000, --Boats
    [15] = 0, --Helicopters
    [16] = 0, --Planes
    [17] = 40000, --Service
    [18] = 350000, --Emergency
    [19] = 0, --Military
    [20] = 350000, --Commercial
    [21] = 0, --Trains

}
