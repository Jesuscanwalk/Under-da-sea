extends Area2D

var is_player_near := false

func _ready() -> void:
	body_entered.connect(func (body: Node) -> void:
		is_player_near = true
			)
	body_exited.connect(func (body:Node) -> void:
		is_player_near = false
		)

func _unhandled_input(event: InputEvent) -> void:
	if is_player_near and event.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://inside.tscn")
		set_process_unhandled_input(false)
