extends Area2D

var oznaceni: int
var zacatek := true

@export var statistiky: Resource


func _ready() -> void:
	_vyber_podoby()


func _vyber_podoby() -> void:
	if zacatek:
		$Tvar.color = Color.SEA_GREEN
	$Poradi.text = str(oznaceni)


func _prejeti(telo: Node2D) -> void:
	if telo.is_in_group('hrac'):
		if zacatek:
			statistiky.pridat_ukol(oznaceni)
		else:
			if not statistiky.overit_ukol(oznaceni):
				return
			statistiky.smazat_ukol(oznaceni)
		queue_free()
