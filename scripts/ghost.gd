extends CharacterBody2D

enum Direction {
	LEFT,
	RIGHT
}

const RUN_SPEED := 100.0

@onready var sprite: AnimatedSprite2D = $sprite
@onready var death: CollisionShape2D = $death/CollisionShape2D
@onready var freeze: CollisionShape2D = $freeze/CollisionShape2D

@export var direction: Direction
var frozen: bool = false
var broadcast: Broadcast

func _ready() -> void:
	match direction:
		Direction.LEFT:
			sprite.flip_h = true
		Direction.RIGHT:
			sprite.flip_h = false
	var parent: Node = self
	while parent != null:
		broadcast = parent as Broadcast
		if broadcast != null:
			broadcast.restart.connect(_on_restart)
			break
		parent = parent.get_parent()

func _physics_process(_delta: float) -> void:
	if frozen:
		return
	match direction:
		Direction.LEFT:
			velocity.x = -RUN_SPEED
		Direction.RIGHT:
			velocity.x = RUN_SPEED
	move_and_slide()
	if is_on_wall():
		match direction:
			Direction.LEFT:
				direction = Direction.RIGHT
				sprite.flip_h = false
			Direction.RIGHT:
				direction = Direction.LEFT
				sprite.flip_h = true

func _on_restart() -> void:
	if !frozen:
		return
	sprite.play("default")
	frozen = false
	death.disabled = false
	freeze.disabled = false
	var poof := preload("res://items/poof.tscn").instantiate() as Node2D
	poof.position = self.position
	get_parent().add_child(poof)

func _on_freeze() -> void:
	sprite.play("frozen")
	frozen = true
	death.disabled = true
	freeze.disabled = true
