extends Area2D
class_name Item

@export var count: int = 1
@export var item: PackedScene
@export var item_index: int = 0
@onready var held: Node2D = $held
var checkpoint_count: int

func _ready() -> void:
	self.checkpoint_count = self.count
	var parent: Node = self
	while parent != null:
		var broadcast := parent as Broadcast
		if broadcast != null:
			broadcast.restart.connect(self._on_restart)
			broadcast.checkpoint.connect(self._on_restart)
			break
		parent = parent.get_parent()

func _on_restart() -> void:
	self.count = self.checkpoint_count

func _on_checkpoint(tunnel: Tunnel) -> void:
	if item_index < tunnel.item_counts.size():
		self.checkpoint_count = tunnel.item_counts[item_index]
