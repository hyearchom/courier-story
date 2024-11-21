extends HBoxContainer

@export var statistiky: Resource
@onready var castka := $PodSebou/Castka
@onready var navyseni := $PodSebou/Navyseni
@onready var zmizeni := $PodSebou/Navyseni/Zmizeni


func _ready() -> void:
	statistiky.finance_zmeneny.connect(upravit_castku)
	upravit_castku(0,0)
	zmizeni.timeout.connect(func()->void: navyseni.hide())
	navyseni.hide()


func upravit_castku(hladina: int, zmena: int) -> void:
	castka.text = str(hladina)
	zobrazit_navyseni(zmena)


func zobrazit_navyseni(hodnota: int) -> void:
	navyseni.show()
	navyseni.text = str(hodnota)
	if hodnota > 0:
		navyseni.self_modulate = Color.WEB_GREEN
	else:
		navyseni.self_modulate = Color.DARK_RED
	zmizeni.start()
