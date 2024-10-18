extends Node2D

const CIL = preload("res://cil.tscn")

@export var vrstvy: Node

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
	umistit_objekt(
		CIL, pozice[0], {'oznaceni': poradi, 'zacatek': true})
	umistit_objekt(
		CIL, pozice[1], {'oznaceni': poradi, 'zacatek': false})


func umistit_objekt(scena: PackedScene, pozice: Vector2, atributy:= {}) -> void:
	var objekt := scena.instantiate()
	for atribut: String in atributy:
		if atribut in objekt:
			objekt.set(atribut, atributy[atribut])
		else:
			push_warning('{0} nemá {1}'.format([objekt.name, atribut]))
	add_child(objekt)
	objekt.position = pozice
