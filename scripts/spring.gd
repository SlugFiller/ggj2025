extends Node2D

func _on_body_entered(body: Node2D) -> void:
	var mouse: Mouse = body as Mouse
	if mouse == null:
		return
	mouse.jump()
