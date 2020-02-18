extends Node

signal GameStart
func _ready():
	Global.gameStart = false
	
func _process(delta):
	#get_node("Area2D/TextureRect").rect_size.x -= delta*100
	#get_node("Area2D/TextureRect").rect_size.y -= delta/100
	#Al empezar el juego vamos reduciendo el nivel
	if(Global.gameStart):
		get_node("map").scale.x -= delta/100
		get_node("map").scale.y -= delta/100

func _on_StartTimer_timeout():
	#Terminar el contador y empieza el juego
	emit_signal("GameStart")
	Global.gameStart = true
	get_node("StarText").text = ""

func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu/Menu.tscn")

func _input(event):
	#Escape para salir al menu
	if (event is InputEventKey):
		if(event.is_pressed()):
			if(event.scancode == KEY_ESCAPE):
				get_tree().change_scene("res://Menu/Menu.tscn")
		#get_tree().quit() 