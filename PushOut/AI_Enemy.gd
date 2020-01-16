extends RigidBody2D

var mover = true
var posicion_salida
var _scale = Vector2(1, 1)
var dashing = false
export var move_speed = 300.0

var p1_die = false
signal p2_die

onready var target = get_node("/root/Game/Player")
onready var center = get_node("/root/Game/CenterPosition")
#Shader
var time = 0

func _ready():
	#Escondemos el joystick del PJ2
	if(!OS.has_feature("mobile")):
		get_parent().get_node("joystick2").hide()

func _physics_process(delta):
	if(!mover):
		position = posicion_salida
		
	if Input.is_action_just_pressed("0"):
		dash()
	
func _integrate_forces(state):
	mover_AI()
	
func _process(delta):
	if(!mover):
		_scale = _scale - Vector2(delta, delta)
		set_scale(_scale)
		emit_signal("p2_die")
	if(scale.x < 0):
		hide()
		
	#Shader
	time += delta
	if(time <= 2):
		$AnimatedSprite.material.set_shader_param("alpha", time/2)
	
func choque(body):
	if(body == get_parent().get_node("Player")):
		apply_central_impulse((position - get_parent().get_node("Player").position)*100)

func _on_Enemy_body_entered(body):
	choque(body)
	
func dash():
	dashing = true
	move_speed = move_speed * 3
	$TimerP2.start()
	print(get_linear_velocity())

func _on_TimerP2_timeout():
	move_speed = 300
	dashing = false
	
func mover_AI():
	var move_direction
	
	if target != null && Global.gameStart:
		var target_position = target.position
		look_at(target_position)
		
		#Vamos a descomponer la distancia al jugador en X e Y
		var delta_X = target_position.x - position.x
		var delta_Y = target_position.y - position.y
		
		if((abs(delta_X) + abs(delta_Y)) > 200):
			move_direction = Vector2(delta_X, delta_Y).normalized()
			
			if(!p1_die):
				linear_velocity.x = move_direction.x * move_speed
				linear_velocity.y = move_direction.y * move_speed
			else:
				#El enemigo deberia frenar si el P1 muere
				set_linear_velocity(get_linear_velocity().slerp(Vector2.ZERO,5))

func _on_Player_p1_die():
	p1_die = true


func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	#Al salir de pantalla el PJ se queda quieto y se achica
	if((body == self) && (body_shape == 1)):
		mover = false
		posicion_salida = position
