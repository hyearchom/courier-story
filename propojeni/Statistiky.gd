extends Resource

signal ukol_prijat
signal ukol_splnen
signal finance_zmeneny

var aktivni_ukoly := {}
var finance: int:
	set(nova_hodnota):
		#printt(finance, nova_hodnota)
		finance_zmeneny.emit(nova_hodnota, nova_hodnota -finance)
		finance = nova_hodnota
	

func pridat_ukol(oznaceni: int, trasa: int) -> void:
	aktivni_ukoly[oznaceni] = trasa 
	ukol_prijat.emit()


func splnit_ukol(oznaceni: int) -> void:
	var prijem: int = vypocet_prijmu(aktivni_ukoly[oznaceni])
	finance += prijem
	
	smazat_ukol(oznaceni)


func vypocet_prijmu(trasa: int) -> int:
	var prijem: int = 4 + trasa/200
	return prijem


func smazat_ukol(oznaceni: int) -> void:
	ukol_splnen.emit()
	aktivni_ukoly.erase(oznaceni)


func overit_ukol(oznaceni: int) -> bool:
	return aktivni_ukoly.has(oznaceni) 
