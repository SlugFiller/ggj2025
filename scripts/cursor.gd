extends Node2D
class_name Cursor

@onready var sprite: AnimatedSprite2D = $sprite
@export var placetarget: Node2D
var hover: Item = null
var hold: Item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			hold = hover
		else:
			if hold != null:
				hold.held.visible = false
				var placed := hold.item.instantiate() as Node2D
				placed.position = event.position
				placetarget.add_child(placed)
			hold = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var position := get_viewport().get_mouse_position()
	sprite.visible = get_viewport().get_visible_rect().has_point(position)
	self.position = position
	var space_state := get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 2
	hover = null
	for obj in space_state.intersect_point(query):
		var check: Item = obj["collider"] as Item
		if check != null:
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
