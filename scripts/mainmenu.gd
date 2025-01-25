extends Node2D

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://intro_cutscene.tscn"))


func _on_quit_pressed() -> void:
	get_tree().quit()
