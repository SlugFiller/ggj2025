extends CharacterBody2D

enum MouseDir {
	LEFT,
	RIGHT
}

@onready var sprite: AnimatedSprite2D = $sprite
@export var direction: MouseDir = MouseDir.RIGHT

const RUN_SPEED := 100.0
const RUN_SPEED_DOWNSLOPE := 150.0
const SLOPE_SPEED := 10.0
const MIN_RUN_SPEED := 1.0
const GRAVITY := 100.0
const MAX_FALL := 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var use_run_animation := true
	var floor_move := false
	if is_on_floor():
		var speed := RUN_SPEED
		if get_real_velocity().y > SLOPE_SPEED:
			speed = RUN_SPEED_DOWNSLOPE
		floor_move = true
		match self.direction:
			MouseDir.LEFT:
				self.velocity.x = -speed
			MouseDir.RIGHT:
				self.velocity.x = speed
		self.velocity.y = 0
	else:
		self.velocity.y += GRAVITY * delta
		if self.velocity.y > MAX_FALL:
			self.velocity.y = MAX_FALL
		use_run_animation = false
	move_and_slide()
	var x_dir := get_real_velocity().x
	if x_dir < -MIN_RUN_SPEED:
		self.direction = MouseDir.LEFT
	elif x_dir > MIN_RUN_SPEED:
		self.direction = MouseDir.RIGHT
	else:
		use_run_animation = false
		if floor_move:
			match self.direction:
				MouseDir.LEFT:
					self.direction = MouseDir.RIGHT
				MouseDir.RIGHT:
					self.direction = MouseDir.LEFT
	if use_run_animation:
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
	sprite.flip_h = self.direction == MouseDir.LEFT
