extends Area2D
class_name Tunnel

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var tunnel_direction: Mouse.MouseDir = Mouse.MouseDir.LEFT
@export var target: Node2D
@export var direction: Mouse.MouseDir
@export var item_counts: Array[int] = []

func _ready() -> void:
	match tunnel_direction:
		Mouse.MouseDir.LEFT:
			animation_player.play("left")
		Mouse.MouseDir.RIGHT:
			animation_player.play("right")

func enter():
	match tunnel_direction:
		Mouse.MouseDir.LEFT:
			animation_player.play("left_enter")
		Mouse.MouseDir.RIGHT:
			animation_player.play("right_enter")
