extends Node
enum Effects {POISON, FIRE, REGENERATION, DEATH, SHOCK}

var effect_tick := 1
var save_slot : int = 1

var inv : Dictionary