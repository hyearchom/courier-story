extends Node2D

@export var DILY_SILNICE := int(100)
const VELIKOST_BUNKY := Vector2i.ONE *50
const VELIKOST_MAPY := Vector2i.ONE *8000

const SIRKA_MAPY := int(VELIKOST_MAPY.x/VELIKOST_BUNKY.x)
const VYSKA_MAPY := int(VELIKOST_MAPY.y/VELIKOST_BUNKY.y)

var mrizka: Array
@onready var vozovka: TileMapLayer = $silnice
@onready var domy: TileMapLayer = $trava

enum Pole {
	MESTO,
	SILNICE
}

func _ready() -> void:
	vytvorit_mrizku()
	vytvorit_cestu()
	obsadit_pole()
	#print(pozice_nahodneho_pole(vozovka))


func vytvorit_mrizku() -> void:
	mrizka = []
	for x in SIRKA_MAPY:
		mrizka.append([])
		for _y in VYSKA_MAPY:
			mrizka[x].append(Pole.MESTO)


func vytvorit_cestu() -> void:
	var delka := int(0)
	var cesta := Vector2i.ZERO
	
	while delka < DILY_SILNICE:
		var smer_pohybu: Vector2i = nahodny_smer()
		var delka_ulice: int = 4
		var cil_pohybu: Vector2i = cesta + smer_pohybu *delka_ulice 
		if cil_pohybu.x >= 0 and cil_pohybu.y >= 0:
			if cil_pohybu.x < SIRKA_MAPY and cil_pohybu.y < VYSKA_MAPY: 
				for _i in range(delka_ulice):
					cesta += smer_pohybu
					mrizka[cesta.x][cesta.y] = Pole.SILNICE
					delka += 1


func nahodny_smer() -> Vector2:
	var smery := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	return smery.pick_random()


func obsadit_pole() -> void:
	for x in SIRKA_MAPY:
		for y in VYSKA_MAPY:
			match mrizka[x][y]:
				Pole.SILNICE:
					vozovka.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
				Pole.MESTO:
					domy.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
	#povrch.set_cells_terrain_connect()


func nahodna_pozice(vrstva: TileMapLayer) -> Vector2:
	var souradnice: Vector2i = vrstva.get_used_cells().pick_random()
	return vrstva.map_to_local(souradnice)
