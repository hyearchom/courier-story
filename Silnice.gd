extends Node2D

const VELIKOST_BUNKY := Vector2i.ONE *50
const VELIKOST_MAPY := Vector2i.ONE *8000

const SIRKA_MAPY := int(VELIKOST_MAPY.x/VELIKOST_BUNKY.x)
const VYSKA_MAPY := int(VELIKOST_MAPY.y/VELIKOST_BUNKY.y)

var mrizka: Array
@onready var povrch: TileMapLayer = $Povrch

enum Pole {
	MESTO,
	SILNICE
}

func _ready() -> void:
	vytvorit_mrizku()
	vytvorit_cestu()
	obsadit_pole()
	#print(mrizka)
	#print(povrch.get_used_cells())

func vytvorit_mrizku() -> void:
	mrizka = []
	for x in SIRKA_MAPY:
		mrizka.append([])
		for _y in VYSKA_MAPY:
			mrizka[x].append(Pole.MESTO)


func vytvorit_cestu() -> void:
	const MAX_DELKA := int(650)
	var delka := int(0)
	var cesta := Vector2.ZERO
	
	while delka < MAX_DELKA:
		var smer_pohybu = nahodny_smer()
		var delka_ulice = 6
		var cil_pohybu = cesta + smer_pohybu *delka_ulice 
		if cil_pohybu.x >= 0 and cil_pohybu.y >= 0:
			if cil_pohybu.x < SIRKA_MAPY and cil_pohybu.y < VYSKA_MAPY: 
				for _i in range(delka_ulice):
					cesta += smer_pohybu
					mrizka[cesta.x][cesta.y] = Pole.SILNICE
					delka += 1


func nahodny_smer() -> Vector2:
	var smery = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	return smery.pick_random()


func obsadit_pole() -> void:
	for x in SIRKA_MAPY:
		for y in VYSKA_MAPY:
			match mrizka[x][y]:
				Pole.SILNICE:
					povrch.set_cell(Vector2i(x, y), 5, Vector2i(1,0))
				Pole.MESTO:
					povrch.set_cell(Vector2i(x, y), 5, Vector2i.ZERO)
	#povrch.set_cells_terrain_connect()
