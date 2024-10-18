extends Resource

signal ukol_prijat
signal ukol_splnen


var aktivni_ukoly := {}


func pridat_ukol(oznaceni: int) -> void:
	aktivni_ukoly[oznaceni] = '' 
	ukol_prijat.emit()


func smazat_ukol(oznaceni: int) -> void:
	aktivni_ukoly.erase(oznaceni)
	ukol_splnen.emit()


func overit_ukol(oznaceni: int) -> bool:
	return aktivni_ukoly.has(oznaceni) 
