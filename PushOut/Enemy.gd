extends RigidBody2D

var MAX_SPEED = 500
var ACCELERATION = 2000
var motion = Vector2()

var Limit 

var mover = true
var posicion_salida
var _scale = Vector2(1, 1)

export var velocity = 5

signal p2_die

func _ready():
	Limit = get_viewport_rect().size

func _physics_process(delta):
	if(mover):
		if Input.is_action_pressed("ui_right"):
			self.apply_impulse(Vector2(0,0), Vector2(velocity,0))
		if Input.is_action_pressed("ui_left"):
			self.apply_impulse(Vector2(0,0), Vector2(-velocity,0))
		if Input.is_action_pressed("ui_up"):
			self.apply_impulse(Vector2(0,0), Vector2(0,-velocity))
		if Input.is_action_pressed("ui_down"):
			self.apply_impulse(Vector2(0,0), Vector2(0,velocity))
	else:
		position = posicion_salida	
		
	if Input.is_action_just_pressed("0"):
		dash()
		
func _process(delta):
	if(!mover):
		_scale = _scale - Vector2(delta, delta)
		set_scale(_scale)
		emit_signal("p2_die")
	if(scale.x < 0):
		hide()
	
func choque(body):
	if(body == get_parent().get_node("Player")):
		self.apply_impulse(position, (position - get_parent().get_node("Player").position)*3)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
	
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func _on_VisibilityNotifier2D_screen_exited():
	pass

func _on_Enemy_body_entered(body):
	choque(body)
	print('ba')


func _on_Area2D_body_exited(body):
		#Al salir de pantalla el PJ se queda quieto y se achica
	print(self, body)
	if(body == self):
		mover = false
		motion = 0
		posicion_salida = position
	
func dash():
#	set_linear_velocity((get_linear_velocity()*2))
	velocity = 40
	$TimerP2.start()
	print(get_linear_velocity())


func _on_TimerP2_timeout():
	velocity = 5
	set_linear_velocity(Vector2(0,0))
