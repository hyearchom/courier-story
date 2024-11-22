extends VBoxContainer

var poradi_dne: int = 0

@onready var interval: Timer = $Interval
@onready var hodiny: ProgressBar = $Hodiny
@onready var den: Label = $Den

func _ready() -> void:
	den_zacal()

func interval_ubehl() -> void:
	hodiny.value += 1
	if hodiny.max_value == hodiny.value:
		den_ubehl()


func den_ubehl() -> void:
	interval.stop()
	get_tree().paused = true


func den_zacal() -> void:
	poradi_dne += 1
	den.text = 'Day {0}'.format([str(poradi_dne)])
	hodiny.value = 0
	interval.start()
