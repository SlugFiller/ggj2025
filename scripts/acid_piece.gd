extends Node2D
class_name AcidPiece

enum PieceType {
	LEFT,
	MIDDLE,
	RIGHT
}

@onready var sprite: AnimatedSprite2D = $sprite
@onready var death: CollisionShape2D = $death/collision
@onready var wall: CollisionShape2D = $wall/collision
@onready var freeze: CollisionShape2D = $freeze/collision
@onready var freezable: Freezable = $freeze
@export var type: PieceType


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match self.type:
		PieceType.LEFT:
			sprite.play("active_left")
		PieceType.MIDDLE:
			sprite.play("active_middle")
		PieceType.RIGHT:
			sprite.play("active_right")
