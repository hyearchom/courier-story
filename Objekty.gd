extends Node2D

const CIL = preload("res://cil.tscn")

@export var vrstvy: Node
@onready var spojnice: Line2D = $Spojnice

func pridat_cile(poradi: int) -> void:
	var pozice := []
	pozice.resize(2)
	#bezpečné vybrání dvou rozdílných bodů vozovky
	for opakovani: int in range(10):
		pozice[0] = vrstvy.nahodna_pozice(vrstvy.vozovka)
		pozice[1] = vrstvy.nahodna_pozice(vrstvy.vozovka)
		if pozice[0] != pozice[1]:
			break
		if opakovani == 10:
			push_error('Nelze vybrat dva rozdílné body vozovky')
			
	#čekání na vymazání předchozího úkolu
	await get_tree().process_frame
	
	#určení vzdálenosti po silnici
	var vzdalenost: int = urcit_delku_cesty(ziskat_cestu(pozice[0], pozice[1]))
	#spojnice.points = navigace
	
	umistit_objekt(
		CIL, pozice[0], {'oznaceni': poradi, 'zacatek': true, 'trasa': vzdalenost})
	umistit_objekt(
		CIL, pozice[1], {'oznaceni': poradi, 'zacatek': false, 'trasa': vzdalenost})


func umistit_objekt(scena: PackedScene, pozice: Vector2, atributy:= {}) -> void:
	var objekt := scena.instantiate()
	for atribut: String in atributy:
		if atribut in objekt:
			objekt.set(atribut, atributy[atribut])
		else:
			push_warning('{0} nemá {1}'.format([objekt.name, atribut]))
	add_child(objekt)
	objekt.position = pozice


func ziskat_cestu(vychozi_misto: Vector2, konecne_misto: Vector2) -> PackedVector2Array:
	# funkce vyžaduje nastavení navigační polygonu přes Node nebo TileMap
	var navigacni_pole := get_world_2d().get_navigation_map()
	var cesta := NavigationServer2D.map_get_path(
		navigacni_pole, 
		vychozi_misto, 
		konecne_misto,
		false
		)
	return cesta


func urcit_delku_cesty(cesta: PackedVector2Array) -> int:
	var celkova_vzdalenost: int = 0
	
	for poradi_bodu: int in (cesta.size() -1):
		var dilci_usek := cesta[poradi_bodu+1] - cesta[poradi_bodu]
		celkova_vzdalenost += floori(dilci_usek.length())
	celkova_vzdalenost = floori(celkova_vzdalenost)
	#print('Vzdálenost trasy je: {0}'.format([celkova_vzdalenost]))
	
	return celkova_vzdalenost
