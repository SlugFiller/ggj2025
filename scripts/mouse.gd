extends RigidBody2D

@onready var sprite: AnimatedSprite2D = $sprite
@onready var groundcheck: ShapeCast2D = $groundcheck

const RUN_SPEED := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var use_run_animation = groundcheck.is_colliding()
	if self.linear_velocity.x > RUN_SPEED:
		sprite.flip_h = false
	elif self.linear_velocity.x < -RUN_SPEED:
		sprite.flip_h = true
	else:
		use_run_animation = false
	if use_run_animation:
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
