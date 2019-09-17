extends Sprite

#onready var p1_live = self.material.get_shader_param("p1_live")

var time = 0

func _process(delta):
	time += delta
	#print(time/1000)
	if(time <= 5):
		material.set_shader_param("alpha", time/5)
		#print(material.get_shader_param("alpha"))