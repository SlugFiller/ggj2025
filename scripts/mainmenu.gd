extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://intro_cutscene.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
