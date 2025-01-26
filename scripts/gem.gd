extends Node2D

enum Type {
	DIAMOND,
	EMERALD,
	RUBY
}

@onready var sprite: AnimatedSprite2D = $sprite
@export var type: Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		Type.DIAMOND:
			sprite.play("diamond")
		Type.EMERALD:
			sprite.play("emerald")
		Type.RUBY:
			sprite.play("ruby")


func _on_body_entered(_body: Node2D) -> void:
	var poof := preload("res://items/sparkle.tscn").instantiate() as Node2D
	poof.position = self.position
	get_parent().add_child(poof)
	queue_free()
