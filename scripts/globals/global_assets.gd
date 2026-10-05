extends Node
var status_effect_assets = [
	{
	"full": "assets/atlas/effects/poison_full.tres",
	"empty": "assets/atlas/effects/poison_empty.tres",
	"active_empty": "assets/atlas/effects/poison_active_empty.tres",
	"active_full": "assets/atlas/effects/poison_active_full.tres"
	},{
	"full": "assets/atlas/effects/shock_full.tres",
	"empty": "assets/atlas/effects/shock_empty.tres",
	"active_empty": "assets/atlas/effects/shock_active_empty.tres",
	"active_full": "assets/atlas/effects/shock_active_full.tres"
	},{
	"full": "assets/atlas/effects/frost_full.tres",
	"empty": "assets/atlas/effects/frost_empty.tres",
	"active_empty": "assets/atlas/effects/frost_active_empty.tres",
	"active_full": "assets/atlas/effects/frost_active_full.tres"
	},{
	"full": "assets/atlas/effects/death_full.tres",
	"empty": "assets/atlas/effects/death_empty.tres",
	"active_empty": "assets/atlas/effects/death_active_empty.tres",
	"active_full": "assets/atlas/effects/death_active_full.tres"
	},{
	"full": "assets/atlas/effects/fire_full.tres",
	"empty": "assets/atlas/effects/fire_empty.tres",
	"active_empty": "assets/atlas/effects/fire_active_empty.tres",
	"active_full": "assets/atlas/effects/fire_active_full.tres"
	},{
	"full": "assets/atlas/effects/regeneration_full.tres",
	"empty": "assets/atlas/effects/regeneration_empty.tres",
	"active_empty": "assets/atlas/effects/regeneration_active_empty.tres",
	"active_full": "assets/atlas/effects/regeneration_active_full.tres"
	},{
	"full": "assets/atlas/effects/sleep_full.tres",
	"empty": "assets/atlas/effects/sleep_empty.tres",
	"active_empty": "assets/atlas/effects/sleep_active_empty.tres",
	"active_full": "assets/atlas/effects/sleep_active_full.tres"
	},{
	"full": "assets/atlas/effects/confusion_full.tres",
	"empty": "assets/atlas/effects/confusion_empty.tres",
	"active_empty": "assets/atlas/effects/confusion_active_empty.tres",
	"active_full": "assets/atlas/effects/confusion_active_full.tres"
	},{
	"full": "assets/atlas/effects/slowness_full.tres",
	"empty": "assets/atlas/effects/slowness_empty.tres",
	"active_empty": "assets/atlas/effects/slowness_active_empty.tres",
	"active_full": "assets/atlas/effects/slowness_active_full.tres"
	},{
	"full": "assets/atlas/effects/speed_full.tres",
	"empty": "assets/atlas/effects/speed_empty.tres",
	"active_empty": "assets/atlas/effects/speed_active_empty.tres",
	"active_full": "assets/atlas/effects/speed_active_full.tres"
	},{
	"full": "assets/atlas/effects/weakness_full.tres",
	"empty": "assets/atlas/effects/weakness_empty.tres",
	"active_empty": "assets/atlas/effects/weakness_active_empty.tres",
	"active_full": "assets/atlas/effects/weakness_active_full.tres"
	},{
	"full": "assets/atlas/effects/strenght_full.tres",
	"empty": "assets/atlas/effects/strenght_empty.tres",
	"active_empty": "assets/atlas/effects/strenght_active_empty.tres",
	"active_full": "assets/atlas/effects/strenght_active_full.tres"
	},
]

var status_effect_anims_assets = [
	"assets/atlas/effect_particles/poison.tres",
	"assets/atlas/effect_particles/shock.tres",
	"assets/atlas/effect_particles/frost.tres",
	"assets/atlas/effect_particles/death.tres",
	"assets/atlas/effect_particles/fire.tres",
	"assets/atlas/effect_particles/regeneration.tres",
	"assets/atlas/effect_particles/sleep.tres",
	"assets/atlas/effect_particles/confusion.tres",
	"assets/atlas/effect_particles/slowness.tres",
	"assets/atlas/effect_particles/speed.tres",
	"assets/atlas/effect_particles/weakness.tres",
	"assets/atlas/effect_particles/strenght.tres",
]

var rarities = [
	"assets/atlas/items/rarities/common.tres",
	"assets/atlas/items/rarities/uncommon.tres",
	"assets/atlas/items/rarities/rare.tres",
	"assets/atlas/items/rarities/ultra_rare.tres",
	"assets/atlas/items/rarities/mythical.tres",
	"assets/atlas/items/rarities/legendary.tres",
]

var rarities_lights = [
	Color8(117, 117, 117, 150),
	Color8(124, 179, 66, 150),
	Color8(0, 188, 212, 150),
	Color8(156, 39, 179, 150),
	Color8(229, 28, 35, 150),
	Color8(253, 216, 53, 150),
]
