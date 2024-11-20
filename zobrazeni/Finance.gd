extends HBoxContainer

@export var statistiky: Resource
@onready var castka := $Castka

func _ready() -> void:
	statistiky.finance_zmeneny.connect(upravit_castku)
	upravit_castku(0,0)


func upravit_castku(_zmena: int, hladina: int) -> void:
	castka.text = str(hladina)
