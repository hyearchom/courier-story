extends Node

var poradi_ukolu: int = 1
var aktivni_ukoly := {}

@export var objekty: Node
@export var statistiky: Resource


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	nabidnout_ukol()
	statistiky.ukol_splnen.connect(nabidnout_ukol)


func nabidnout_ukol() -> void:
	objekty.pridat_cile(poradi_ukolu)
	poradi_ukolu += 1
