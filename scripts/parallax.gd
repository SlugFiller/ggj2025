extends Node2D

@export var max_range: float = 100.0
@export var ratio: float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var relative := get_viewport().get_camera_2d().global_position.y - self.global_position.y
	relative *= ratio
	relative = clampf(relative, -max_range, max_range)

	for child in get_children():
		var node2d := child as Node2D
		if node2d != null:
			node2d.position.y = relative
