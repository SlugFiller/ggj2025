extends CharacterBody2D

enum MouseDir {
	LEFT,
	RIGHT
}

@onready var sprite: AnimatedSprite2D = $sprite
@export var direction: MouseDir = MouseDir.RIGHT

const RUN_SPEED := 100.0
const MIN_RUN_SPEED := 1.0
const GRAVITY := 100.0
const MAX_FALL := 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var use_run_animation := true
	if is_on_floor():
		match self.direction:
			MouseDir.LEFT:
				self.velocity.x = -RUN_SPEED
			MouseDir.RIGHT:
				self.velocity.x = RUN_SPEED
		self.velocity.y = 0
	else:
		self.velocity.y += GRAVITY * delta
		if self.velocity.y > MAX_FALL:
			self.velocity.y = MAX_FALL
		use_run_animation = false
	move_and_slide()
	if use_run_animation && abs(get_real_velocity().x) < MIN_RUN_SPEED:
		use_run_animation = false
	if use_run_animation:
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
