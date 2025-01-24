extends Area2D
class_name Item

@export var count: int = 1
@export var item: PackedScene
@onready var held: Node2D = $held
var checkpoint_count: int

func _ready() -> void:
	self.checkpoint_count = self.count

func _on_restart() -> void:
	self.count = self.checkpoint_count
