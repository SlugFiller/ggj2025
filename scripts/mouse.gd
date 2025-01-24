extends CharacterBody2D
class_name Mouse

enum MouseDir {
	LEFT,
	RIGHT
}


@onready var broadcast: Broadcast = $".."
@onready var sprite: AnimatedSprite2D = $sprite
@onready var fan_detector: Area2D = $fan_detector
@onready var death_detector: Area2D = $death_detector
@export var direction: MouseDir = MouseDir.RIGHT
@onready var tunnel_detector: Area2D = $tunnel_detector
var checkpoint: Vector2
var checkpoint_direction: MouseDir
var scrollnimation: float = 0.0
var deathfall: bool = false
var respawn: bool = false
var y_shift: float = 0.0

const RUN_SPEED := 200.0
const RUN_SPEED_DOWNSLOPE := 250.0
const SLOPE_SPEED := 10.0
const MIN_RUN_SPEED := 1.0
const GRAVITY := 100.0
const FAN_GRAVITY := 300.0
const MAX_FALL := 500.0
const DEAD_TIME := 2.0
const TUNNEL_TIME := 3.0
const TIME_SCROLL := 1.0
const DEATH_FALL_SPEED := 800.0
const TIME_DEATH_FALL := 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_checkpoint()

func set_checkpoint() -> void:
	self.checkpoint = self.position
	self.checkpoint_direction = self.direction

func _physics_process(delta: float) -> void:
	if self.scrollnimation > 0.0:
		return
	elif self.respawn:
		self.respawn = false
		self.position = self.checkpoint
		self.direction = self.checkpoint_direction
		self.deathfall = false
		self.velocity = Vector2.ZERO
		self.y_shift = 0.0
		sprite.position = Vector2.ZERO
		sprite.play("idle")
		move_and_slide()
		return
	if death_detector.has_overlapping_bodies():
		self.deathfall = true
		self.scrollnimation = DEAD_TIME
		sprite.play("death")
		return
	for tunnel_candidate in tunnel_detector.get_overlapping_areas():
		var tunnel := tunnel_candidate as Tunnel
		if tunnel == null:
			continue
		self.checkpoint = tunnel.target.global_position
		self.checkpoint_direction = tunnel.direction
		for item in tunnel.target.get_children():
			var itemcount := item as ItemCount
			if itemcount == null:
				continue
			itemcount.item.checkpoint_count = itemcount.count
		self.scrollnimation = TUNNEL_TIME
		return
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
		var gravity: float = GRAVITY
		if fan_detector.has_overlapping_areas():
			self.velocity.x = 0
			gravity = FAN_GRAVITY
		self.velocity.y += gravity * delta
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

func _process(delta: float) -> void:
	if self.scrollnimation > 0.0:
		var should_poof: bool = true
		if self.scrollnimation < TIME_SCROLL:
			should_poof = false
		if self.scrollnimation > delta:
			self.scrollnimation -= delta
		else:
			self.scrollnimation = 0
			self.respawn = true
		if self.scrollnimation < TIME_SCROLL:
			if should_poof:
				broadcast.restart.emit()
			self.y_shift = (self.checkpoint.y - self.position.y) * (1.0 - self.scrollnimation / TIME_SCROLL)
		if self.deathfall && self.scrollnimation < TIME_DEATH_FALL:
			sprite.position.y += DEATH_FALL_SPEED * delta
