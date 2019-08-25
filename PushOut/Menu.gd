extends CanvasLayer

signal Start_Game



func _on_Button_pressed():
	emit_signal("Start_Game")
