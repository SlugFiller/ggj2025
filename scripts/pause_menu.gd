extends Node2D

@onready var pause: TextureButton = $button
@onready var menu: Node2D = $menu


func _on_pause() -> void:
	pause.visible = false
	menu.visible = true
	get_tree().paused = true


func _on_unpause() -> void:
	pause.visible = true
	menu.visible = false
	get_tree().paused = false


func _on_quit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mainmenu.tscn")
