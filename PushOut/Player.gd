extends RigidBody2D

signal p1_die

var mover = true
var posicion_salida
var _scale = Vector2(1, 1)
var dashing = false

onready var joystick = get_parent().get_node("joystick/joystick_Button")
export var move_speed = 300.0
#Shader
var time = 0

var power_up = false
var pw_type = ""
var timer = null
export var delay = 5

#Buttons
export var right = ""
export var left = ""
export var down = ""
export var up = ""
export var dash = ""

func _ready():
	if(!OS.has_feature("mobile")):
		if(get_parent().get_node("joystick") != null):
			get_parent().get_node("joystick").hide()

func _physics_process(delta):
	if(!mover):
		position = posicion_salida
		
	if Input.is_action_just_pressed(dash) && !dashing:
		dash()
		
func get_move_direction() -> Vector2:
	return joystick.get_value()

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed(right)) - int(Input.is_action_pressed(left))
	axis.y = int(Input.is_action_pressed(down)) - int(Input.is_action_pressed(up))
	return axis.normalized()
		
func _process(delta):
	if(!mover):
		_scale = _scale - Vector2(delta, delta)
		set_scale(_scale)
		emit_signal("p1_die")
	if(scale.x < 0):
		hide()
	
	#Shader
	time += delta
	if(time <= 2):
		$Sprite_Player.material.set_shader_param("alpha", time/2)
	
func choque(body):
	#Si choco con el enemigo
	if(body == get_parent().get_node("Enemy")):
		#print('chocaJugador')
		apply_central_impulse((position - get_parent().get_node("Enemy").position)*100)
		get_parent().get_node("Sound").play()
	
func _on_Player_body_entered(body):
	choque(body)
	
func _integrate_forces( state ):
	var contacts
	if state.get_contact_count() > 0:
		contacts = state.get_contact_local_position(0)
	
	var move_direction
	
	if(OS.has_feature("mobile")):
		move_direction = get_move_direction()
	else:
		move_direction = get_input_axis()
		
	if(mover && Global.gameStart):
		linear_velocity.x = move_direction.x * move_speed
		linear_velocity.y = move_direction.y * move_speed
	
	if(state.get_contact_count() > 0):
		#print(contacts)
		var particles = load("res://Particles.tscn").instance()
		particles.set_position(contacts)
		get_parent().add_child(particles)
	
func dash():
	dashing = true
	move_speed = move_speed * 3
	print(get_linear_velocity())
	$TimerPJ.start()
	
func _on_TimerPJ_timeout():
	move_speed = 300
	dashing = false
	
func power_up(_pw_type):
	power_up = true
	pw_type = _pw_type
	create_timer()
	if pw_type == "expand":
		pw_expand()
	if pw_type == "speed":
		pw_speed()

func pw_speed():
	if(power_up):
		move_speed = move_speed * 2
	else:
		move_speed = move_speed / 2

func pw_expand():
	if(power_up):
		self.get_child(0).set_scale(self.get_child(0).get_scale()*2)
		self.get_child(1).set_scale(self.get_child(1).get_scale()*2)
	else:
		self.get_child(0).set_scale(self.get_child(0).get_scale()/2)
		self.get_child(1).set_scale(self.get_child(1).get_scale()/2)
	
func on_timeout_pw_complete():
	power_up = false
	if pw_type == "expand":
		pw_expand()
	if pw_type == "speed":
		pw_speed()
	
func create_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "on_timeout_pw_complete")
	add_child(timer)
	timer.start()

func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	#Al salir de pantalla el PJ se queda quieto y se achica
	if((body == self) && (body_shape == 1)):
		mover = false
		posicion_salida = position
