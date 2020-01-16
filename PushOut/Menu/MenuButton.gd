extends Button

export(Array, String) var scenes
var scene_to_load

func _ready():
	if(scenes.size() > 0): 
		scene_to_load = scenes[randi () % scenes.size()]