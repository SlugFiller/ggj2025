extends Node2D

@onready var trigger: Area2D = $trigger
var used: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if used:
		return
	for candidate in trigger.get_overlapping_areas():
		var freezable := candidate as Freezable
		if freezable == null:
			continue
		freezable.frozen.emit()
		used = true
	if !used:
		return
	var poof := preload("res://items/poof.tscn").instantiate() as Node2D
	poof.position = self.position
	get_parent().add_child(poof)
	get_parent().add_child(preload("res://items/freeze_effect.tscn").instantiate())
	queue_free()
