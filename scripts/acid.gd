extends Node2D

@onready var poof: AnimatedSprite2D = $poof
var frozen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		var piece: AcidPiece = child as AcidPiece
		if piece == null:
			continue
		piece.freezable.frozen.connect(self._on_freeze)
	var parent: Node = self
	while parent != null:
		var broadcast := parent as Broadcast
		if broadcast != null:
			broadcast.restart.connect(self._on_restart)
			break
		parent = parent.get_parent()

func _on_freeze() -> void:
	frozen = true
	for child in get_children():
		var piece: AcidPiece = child as AcidPiece
		if piece == null:
			continue
		piece.death.disabled = true
		piece.wall.disabled = false
		piece.freeze.disabled = true
		match piece.type:
			AcidPiece.PieceType.LEFT:
				piece.sprite.play("frozen_left")
			AcidPiece.PieceType.MIDDLE:
				piece.sprite.play("frozen_middle")
			AcidPiece.PieceType.RIGHT:
				piece.sprite.play("frozen_right")

func _on_restart() -> void:
	if !frozen:
		return
	frozen = false
	poof.play("poof")
	for child in get_children():
		var piece: AcidPiece = child as AcidPiece
		if piece == null:
			continue
		piece.death.disabled = false
		piece.wall.disabled = true
		piece.freeze.disabled = false
		match piece.type:
			AcidPiece.PieceType.LEFT:
				piece.sprite.play("active_left")
			AcidPiece.PieceType.MIDDLE:
				piece.sprite.play("active_middle")
			AcidPiece.PieceType.RIGHT:
				piece.sprite.play("active_right")
