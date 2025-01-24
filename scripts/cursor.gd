extends Node2D
class_name Cursor

@onready var mouse: Mouse = $"../../Mouse"
@onready var sprite: AnimatedSprite2D = $sprite
@onready var placetarget: Node2D = $"../../placetarget"
@onready var camera: Camera2D = $"../../Camera2D"
var hover: Item = null
var hold: Item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			hold = hover
		else:
			if hold != null:
				hold.count -= 1
				hold.held.visible = false
				var placed := hold.item.instantiate() as Node2D
				placed.position = event.position + camera.position + Vector2(0, -540)
				placetarget.add_child(placed)
			hold = null
	elif event is InputEventMouseMotion:
		self.position = event.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var position := get_viewport().get_mouse_position()
	sprite.visible = get_viewport().get_visible_rect().has_point(position)
	self.position = position
	hover = null
	if mouse.scrollnimation > 0:
		if hold != null:
			hold.held.visible = false
		hold = null
	else:
		var space_state := get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.canvas_instance_id = get_parent().get_instance_id()
		query.position = position
		query.collide_with_areas = true
		query.collide_with_bodies = false
		query.collision_mask = 1
		for obj in space_state.intersect_point(query):
			var check: Item = obj["collider"] as Item
			if check != null && check.count > 0:
				hover = check
				break
	if hold != null:
		hold.held.visible = sprite.visible
		hold.held.position = position
		if sprite.animation != "pickup":
			sprite.play("pickup")
	elif hover != null:
		if sprite.animation != "hover":
			sprite.play("hover")
	else:
		if sprite.animation != "default":
			sprite.play("default")

func _on_restart() -> void:
	for placed in placetarget.get_children():
		placed.queue_free()
