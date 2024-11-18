extends Resource

var parametry := {
	'rozchod_kol': 40, 
	'uhel_zaboceni': 15,
	'vykon_motoru': 600,
	'sila_brzdeni': 400,
	'max_zpatecky': 300,
	'odpor_vetru': 0.001 # upravit se systémem počasí
}

var povrch := {
	'silnice':
		{
			'odpor_povrchu': 0.08,
			'rychlost_smyku': 400,
			'rychla_trakce': 0.1,
			'pomala_trakce': 0.9
		},
	'trava':
		{
			'odpor_povrchu': 1.5,
			'rychlost_smyku': 400,
			'rychla_trakce': 0.1,
			'pomala_trakce': 0.9
		}
}
