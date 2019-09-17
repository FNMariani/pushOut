extends Label

func _process(delta):
	set_text("x: " + str(Input.get_accelerometer().x) + " y: " + str(Input.get_accelerometer().y) + 
	" z: " + str(Input.get_accelerometer().z))