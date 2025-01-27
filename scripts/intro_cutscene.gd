extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
var last_position: float = 0.0

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://game.tscn")

func _process(_delta: float) -> void:
	var current_position = video_stream_player.stream_position
	animation_player.advance(current_position - last_position)
	last_position = current_position

func _on_finished() -> void:
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://game.tscn"))
