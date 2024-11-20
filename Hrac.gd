extends CharacterBody2D

@export var vuz: Resource

# charakteristiky vozu
var rozchod_kol: float 
var uhel_zaboceni: float
var vykon_motoru: float
var sila_brzdeni: float
var max_zpatecky: float

# charakteristiky prostredi
var odpor_povrchu: float
var odpor_vetru: float
var rychlost_smyku: float
var rychla_trakce: float
var pomala_trakce: float

var zaboceni: float
var zrychleni: Vector2
var teren: String

func _ready() -> void:
	nacist_vuz()
	nacist_povrch('silnice')


func _physics_process(delta: float) -> void:
	zmena_zrychleni()
	zmena_zataceni(delta)
	velocity += zrychleni *delta
	move_and_slide()
	
	for i in get_slide_collision_count():
		var srazka := get_slide_collision(i)
		print("I collided with ", srazka.get_collider().name)


func nacist_vuz() -> void:
	for parametr: String in vuz.parametry:
		set(parametr, vuz.parametry[parametr])
		#printt(parametr, vuz.parametry[parametr])


func nacist_povrch(nazev:='silnice') -> void:
	for parametr: String in vuz.povrch[nazev]:
		set(parametr, vuz.povrch[nazev][parametr])
		#printt(parametr, vuz.povrch[nazev][parametr])


func zmena_zrychleni() -> void:
	zrychleni = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		zrychleni = transform.x * vykon_motoru
	elif Input.is_action_pressed("ui_down"):
		zrychleni = -transform.x * vykon_motoru
	
	if Input.is_action_pressed("ui_accept"):
		zrychleni -= velocity.normalized() *sila_brzdeni
	
	odpor_prostredi()


func zmena_zataceni(delta: float) -> void:
	var smer_otoceni: int = 0
	if Input.is_action_pressed("ui_right"):
		smer_otoceni += 1
	if Input.is_action_pressed("ui_left"):
		smer_otoceni -= 1
	zaboceni = smer_otoceni *deg_to_rad(uhel_zaboceni)
	
	var trakce: float = pomala_trakce if velocity.length() < rychlost_smyku else rychla_trakce
	var zadni_kolo: Vector2 = position - transform.x * rozchod_kol / 2.0
	var predni_kolo: Vector2 = position + transform.x * rozchod_kol / 2.0
	zadni_kolo += velocity * delta
	predni_kolo += velocity.rotated(zaboceni) * delta
	var novy_smer: Vector2 = (predni_kolo - zadni_kolo).normalized()
	
	if urceni_smeru(novy_smer) > 0:
		velocity = lerp(velocity, novy_smer *velocity.length(), trakce)
	else:
		velocity = -novy_smer *velocity.length()
		#velocity = -novy_smer *min(max_zpatecky, velocity.length())
	rotation = novy_smer.angle()
	#printt(velocity, rotation, zadni_kolo, predni_kolo)


func urceni_smeru(zacileni:Vector2) -> int:
	var orientace: int = round(zacileni.dot(velocity.normalized()))
	return orientace if orientace != 0 else -1


func odpor_prostredi() -> void:
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var povrch: Vector2 = velocity *odpor_povrchu
	var vitr: Vector2 = velocity * velocity.length() * odpor_vetru
	if velocity.length() < 100:
		povrch *= 10
	zrychleni -= povrch +vitr


func _zmena_povrchu(telo: Node2D) -> void:
	var oznaceni := telo.name
	if teren != oznaceni:
		nacist_povrch(oznaceni)
		teren = oznaceni
		print('Detekovan povrch: {0}'.format([oznaceni]))
