extends PanelContainer

@export var star_number0: TextureRect
@export var star_number1: TextureRect
@export var sm64_key0: TextureRect
@export var sm64_key1: TextureRect

@export var dx_instrument_count: Label
@export var dx_ocarina: TextureRect
@export var dx_ballad: TextureRect

@export var oot_dungeon_reward_count: Label
@export var oot_bow: TextureRect
@export var oot_magic: TextureRect
@export var oot_light_arrow: TextureRect

@export var mm_remains_count: Label
@export var mm_oath: TextureRect

@export var alttp_triforce_count: Label

@export var minish_sword_count: Label
@export var minish_sword: TextureRect
@export var minish_element_count: Label

@export var oos_essence_count: Label

@export var checks_count: Label

func _ready():
	Counter.update.connect(update)


func update():
	update_sm64()
	update_dx()
	update_oot()
	update_mm()
	update_alttp()
	update_minish_cap()
	update_oos()
	update_other()


func update_sm64():
	var stars := str(Counter.sm64_stars).pad_zeros(3)
	set_sm64_number_texture_number(star_number0, int(stars[1]))
	set_sm64_number_texture_number(star_number1, int(stars[2]))
	
	set_sm64_key_texture(sm64_key0, Counter.sm64_keys > 0)
	set_sm64_key_texture(sm64_key1, Counter.sm64_keys > 1)


func set_sm64_number_texture_number(texture: TextureRect, number: int):
	var t: AtlasTexture = texture.texture
	t.region.position.x = 48 * number


func set_sm64_key_texture(texture: TextureRect, found: bool):
	var t: AtlasTexture = texture.texture
	t.region.position.x = 373 if found else 0


func update_dx():
	const INSTRUMENTS := [
		"Links Awakening DX::Full Moon Cello",
		"Links Awakening DX::Conch Horn",
		"Links Awakening DX::Sea Lily's Bell",
		"Links Awakening DX::Surf Harp",
		"Links Awakening DX::Wind Marimba",
		"Links Awakening DX::Coral Triangle",
		"Links Awakening DX::Organ of Evening Calm",
		"Links Awakening DX::Thunder Drum",
	]
	
	var instrument_count := 0
	for item in Counter.items:
		if item in INSTRUMENTS:
			instrument_count += 1
	
	dx_instrument_count.text = str(instrument_count) + "/" + str(Counter.dx_instrument_count)
	dx_ocarina.texture.region.position.x = 8 if "Links Awakening DX::Ocarina" in Counter.items else 0
	dx_ballad.texture.region.position.x = 16 if "Links Awakening DX::Ballad of the Wind Fish" in Counter.items else 0


func update_oot():
	const DUNGEON_REWARDS := [
		"Ship of Harkinian::Kokiri's Emerald",
		"Ship of Harkinian::Goron's Ruby",
		"Ship of Harkinian::Zora's Sapphire",
		"Ship of Harkinian::Forest Medallion",
		"Ship of Harkinian::Fire Medallion",
		"Ship of Harkinian::Water Medallion",
		"Ship of Harkinian::Shadow Medallion",
		"Ship of Harkinian::Spirit Medallion",
		"Ship of Harkinian::Light Medallion",
	]
	var dungeon_reward_count := 0
	for item in Counter.items:
		if item in DUNGEON_REWARDS:
			dungeon_reward_count += 1
	
	oot_dungeon_reward_count.text = str(dungeon_reward_count) + "/" + str(Counter.oot_dungeon_reward_count)
	oot_magic.texture.region.position.x = 32 * Counter.oot_magic_meters
	oot_bow.texture.region.position.x = 32 if Counter.oot_bows > 0 else 0
	oot_light_arrow.texture.region.position.x = 32 if "Ship of Harkinian::OoT Light Arrow" in Counter.items else 0


func update_mm():
	const REMAINS := [
		"Majora's Mask Recompiled::Odolwa's Remains",
		"Majora's Mask Recompiled::Goht's Remains",
		"Majora's Mask Recompiled::Gyorg's Remains",
		"Majora's Mask Recompiled::Twinmold's Remains",
	]

	var remains := 0
	for item in Counter.items:
		if item in REMAINS:
			remains += 1
	
	mm_remains_count.text = str(remains) + "/" + str(Counter.mm_remains_count)
	mm_oath.texture.region.position.x = 16 if "Majora's Mask Recompiled::Oath to Order" in Counter.items else 0


func update_alttp():
	alttp_triforce_count.text = "%02d" % [Counter.alttp_triforce_pieces] + "/" + str(Counter.alttp_triforce_pieces_count)


func update_minish_cap():
	const ELEMENTS := [
		"The Minish Cap::Earth Element",
		"The Minish Cap::Fire Element",
		"The Minish Cap::Water Element",
		"The Minish Cap::Wind Element",
	]

	var elements := 0
	for item in Counter.items:
		if item in ELEMENTS:
			elements += 1
	
	minish_sword_count.text = str(Counter.minish_swords) + "/" + str(Counter.minish_swords_count)
	minish_sword.texture.region.position.x = 16 * Counter.minish_swords
	minish_element_count.text = str(elements) + "/" + str(Counter.minish_elements_count)


func update_oos():
	const ESSENCES := [
		"The Legend of Zelda - Oracle of Seasons::Fertile Soil",
		"The Legend of Zelda - Oracle of Seasons::Gift of Time",
		"The Legend of Zelda - Oracle of Seasons::Bright Sun",
		"The Legend of Zelda - Oracle of Seasons::Soothing Rain",
		"The Legend of Zelda - Oracle of Seasons::Nurturing Warmth",
		"The Legend of Zelda - Oracle of Seasons::Blowing Wind",
		"The Legend of Zelda - Oracle of Seasons::Seed of Life",
		"The Legend of Zelda - Oracle of Seasons::Changing Seasons",
	]

	var essences := 0
	for item in Counter.items:
		if item in ESSENCES:
			essences += 1
	
	oos_essence_count.text = str(essences) + "/" + str(Counter.oos_essences_count)


func update_other():
	checks_count.text = "Total Checks\n" + str(Counter.checks) + "/" + str(Counter.total_checks)
