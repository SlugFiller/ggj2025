extends Node2D

@onready var freeze1: AudioStreamPlayer = $freeze1
@onready var freeze2: AudioStreamPlayer = $freeze2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0, 1) > 0:
		freeze1.play()
	else:
		freeze2.play()


func _on_finished() -> void:
	queue_free()
