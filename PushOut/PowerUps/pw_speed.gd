extends Area2D

var timer = null
var delay = 2

func _ready():
	create_timer()

func _on_pw_expand_body_entered(body):
	if "Player" in body.name:
		body.power_up("speed")
		queue_free()
	if "Enemy" in body.name:
		body.power_up("speed")
		queue_free()
		
func create_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(rand_range(2, 4))
	timer.connect("timeout", self, "on_timeout")
	add_child(timer)
	timer.start()
	
func on_timeout():
	queue_free()