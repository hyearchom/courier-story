extends CharacterBody2D

const ROZCHOD_KOL := 40 
const UHEL_ZABOCENI := 15
const VYKON_MOTORU := 600
const SILA_BRZDENI := 400
const MAX_ZPATECKY := 300

const ODPOR_POVRCHU := 0.08
const ODPOR_VETRU := 0.001
const RYCHLOST_SMYKU = 400
const RYCHLA_TRAKCE = 0.1
const POMALA_TRAKCE = 0.9

var zaboceni: float
var zrychleni: Vector2

func _physics_process(delta: float) -> void:
	zmena_zrychleni()
	zmena_zataceni(delta)
	velocity += zrychleni *delta
	move_and_slide()


func zmena_zrychleni() -> void:
	zrychleni = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		zrychleni = transform.x * VYKON_MOTORU
	elif Input.is_action_pressed("ui_down"):
		zrychleni = -transform.x * VYKON_MOTORU
	
	if Input.is_action_pressed("ui_accept"):
		zrychleni -= velocity.normalized() *SILA_BRZDENI
	
	odpor_prostredi()

func zmena_zataceni(delta):
	var smer_otoceni = 0
	if Input.is_action_pressed("ui_right"):
		smer_otoceni += 1
	if Input.is_action_pressed("ui_left"):
		smer_otoceni -= 1
	zaboceni = smer_otoceni *deg_to_rad(UHEL_ZABOCENI)
	
	var trakce = POMALA_TRAKCE if velocity.length() < RYCHLOST_SMYKU else RYCHLA_TRAKCE
	var zadni_kolo = position - transform.x * ROZCHOD_KOL / 2.0
	var predni_kolo = position + transform.x * ROZCHOD_KOL / 2.0
	zadni_kolo += velocity * delta
	predni_kolo += velocity.rotated(zaboceni) * delta
	var novy_smer = (predni_kolo - zadni_kolo).normalized()
	
	if urceni_smeru(novy_smer) > 0:
		velocity = lerp(velocity, novy_smer *velocity.length(), trakce)
	else:
		velocity = -novy_smer *velocity.length()
		#velocity = -novy_smer *min(MAX_ZPATECKY, velocity.length())
	rotation = novy_smer.angle()
	#printt(velocity, rotation, zadni_kolo, predni_kolo)

func urceni_smeru(zacileni) -> float:
	var orientace = round(zacileni.dot(velocity.normalized()))
	return orientace if orientace != 0 else -1


func odpor_prostredi():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var povrch = velocity *ODPOR_POVRCHU
	var vitr = velocity * velocity.length() * ODPOR_VETRU
	if velocity.length() < 100:
		povrch *= 10
	zrychleni -= povrch +vitr
