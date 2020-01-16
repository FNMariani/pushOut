extends Node

export var powerups = [
	preload("res://PowerUps/pw_expand.tscn"),
	preload("res://PowerUps/pw_speed.tscn")
]

export (NodePath) var timerPath
onready var timerNode = get_node(timerPath)

export (float) var minWaitTime
export (float) var maxWaitTime

func _ready():
	randomize()
	timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
	timerNode.start()

func _on_Timer_timeout():
	randomize()
	var pw = powerups[randi() % powerups.size()].instance()
	get_parent().add_child(pw)
	
	pw.set_position(Vector2(
	rand_range(get_parent().get_node("Area2D/left").get_global_position().x,
	get_parent().get_node("Area2D/right").get_global_position().x),
	rand_range(get_parent().get_node("Area2D/up").get_global_position().y,
	get_parent().get_node("Area2D/down").get_global_position().y)))
	print(pw.position)
	
	timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
	timerNode.start()
