extends Area2D

@onready var interaction_area: CollisionShape2D = $"interaction area"

const lines: Array[String] = [
	"get fish",
	"me hungry"
]

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		DialogManager.start_dialog(global_position, lines)
 
