extends RigidBody2D

var MAX_SPEED = 500
var motion = Vector2()

var limit 
signal golpe
signal p1_die

var mover = true
var posicion_salida
var _scale = Vector2(1, 1)

export var velocity = 5

func _ready():
	limit = get_viewport_rect().size

func _physics_process(delta):
	if(mover):
		if Input.is_action_pressed("D"):
			self.apply_impulse(Vector2(0,0), Vector2(velocity,0))
		if Input.is_action_pressed("A"):
			self.apply_impulse(Vector2(0,0), Vector2(-velocity,0))
		if Input.is_action_pressed("W"):
			self.apply_impulse(Vector2(0,0), Vector2(0,-velocity))
		if Input.is_action_pressed("S"):
			self.apply_impulse(Vector2(0,0), Vector2(0,velocity))
	else:
		position = posicion_salida	
		
	if Input.is_action_just_pressed("ui_select"):
		dash()
		
func _process(delta):
	if(!mover):
		_scale = _scale - Vector2(delta, delta)
		set_scale(_scale)
		emit_signal("p1_die")
	if(scale.x < 0):
		hide()
	
	
func choque(body):
	#Si choco con el enemigo
	if(body == get_parent().get_node("Enemy")):
		self.apply_impulse(position, (position - get_parent().get_node("Enemy").position)*3)
	

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	axis.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
	
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func _on_Player_body_entered(body):
	#hide()
	#emit_signal("golpe")
	#$Collider.disabled = true
	choque(body)
	
func _integrate_forces( state ):
	var contacts = state.get_contact_local_position(0)
	
	if(state.get_contact_count() > 0):
		print(contacts)
		var particles = load("res://Particles.tscn").instance()
		particles.set_position(contacts)	
		get_parent().add_child(particles)
		#$Particles.position = contacts

func _on_Area2D_body_exited(body):
	#Al salir de pantalla el PJ se queda quieto y se achica
	if(body == self):
		mover = false
		motion = 0
		posicion_salida = position
	#Esconder
	#body.hide()
	#Cargar escena de menu
	#get_tree().change_scene('res://Menu.tscn')

	#if body.name == 'Player':
		#position = get_parent().get_node("PlayerPosition").position
	#else:
		#body.position = get_parent().get_node("EnemyPosition").position
		
func dash():
#	set_linear_velocity((get_linear_velocity()*2))
	velocity = 40
	$TimerPJ.start()
	print(get_linear_velocity())


func _on_TimerPJ_timeout():
	velocity = 5
	set_linear_velocity(Vector2(0,0))
