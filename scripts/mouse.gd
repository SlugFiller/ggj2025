extends CharacterBody2D
class_name Mouse

enum MouseDir {
	LEFT,
	RIGHT
}


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
var is_ending: bool = false
var y_shift: float = 0.0
var broadcast: Broadcast

const RUN_SPEED := 300.0
const RUN_SPEED_DOWNSLOPE := 350.0
const SLOPE_SPEED := 10.0
const MIN_RUN_SPEED := 1.0
const GRAVITY := 400.0
const FAN_GRAVITY := 500.0
const MAX_FALL := 99999.0
const JUMP_SPEED := 400.0
const DEAD_TIME := 2.0
const TUNNEL_TIME := 3.0
const TIME_SCROLL := 1.0
const DEATH_FALL_SPEED := 800.0
const TIME_DEATH_FALL := 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_checkpoint()
	var parent: Node = self
	while parent != null:
		broadcast = parent as Broadcast
		if broadcast != null:
			broadcast.checkpoint.connect(_on_checkpoint)
			break
		parent = parent.get_parent()

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
		broadcast.checkpoint.emit(tunnel)
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
			if self.is_ending:
				get_tree().change_scene_to_file("res://intro.tscn")
				return
			if should_poof:
				broadcast.restart.emit()
			self.y_shift = (self.checkpoint.y - self.position.y) * (1.0 - self.scrollnimation / TIME_SCROLL)
		if self.deathfall && self.scrollnimation < TIME_DEATH_FALL:
			sprite.position.y += DEATH_FALL_SPEED * delta

func jump() -> void:
	if self.scrollnimation > 0.0:
		return
	self.velocity.y = -JUMP_SPEED

func _on_checkpoint(tunnel: Tunnel) -> void:
	if tunnel.target != null:
		self.checkpoint = tunnel.target.global_position
	else:
		self.checkpoint = self.position
		self.is_ending = true
	self.checkpoint_direction = tunnel.direction
