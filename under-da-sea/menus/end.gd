extends Control

@onready var retry: Button = %retry
@onready var quit: Button = %quit


func _on_retry_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()
