extends Label

var timer = null
export var delay = 2

func create_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	timer.start()
	
func _on_Player_p1_die():
	#Comprobamos que el label este en blanco para evitar reemplazarlo si el ganador cae luego del perdedor
	if(text == ""):
		text = "P2 Gana!"
	create_timer()

func _on_Enemy_p2_die():
	#Comprobamos que el label este en blanco para evitar reemplazarlo si el ganador cae luego del perdedor
	if(text == ""):
		text = "P1 Gana!"
	create_timer()

func on_timeout_complete():
	get_tree().change_scene("res://Menu/Menu.tscn")
	#get_tree().reload_current_scene()
