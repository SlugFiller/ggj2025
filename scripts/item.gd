extends Area2D
class_name Item

@onready var held: Node2D = $held
@onready var count_display: AnimatedSprite2D = $count_display

@export var count: int = 1
@export var item: PackedScene
@export var item_index: int = 0
var checkpoint_count: int

func _ready() -> void:
	self.checkpoint_count = self.count
	var parent: Node = self
	while parent != null:
		var broadcast := parent as Broadcast
		if broadcast != null:
			broadcast.restart.connect(self._on_restart)
			broadcast.checkpoint.connect(self._on_checkpoint)
			break
		parent = parent.get_parent()
	update_count()

func _on_restart() -> void:
	self.count = self.checkpoint_count
	update_count()

func _on_checkpoint(tunnel: Tunnel) -> void:
	if item_index < tunnel.item_counts.size():
		self.checkpoint_count = tunnel.item_counts[item_index]

func update_count():
	count_display.frame = self.count
