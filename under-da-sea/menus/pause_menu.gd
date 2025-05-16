extends Control

@onready var ui_panel_container: PanelContainer = %UIPanelContainer
@onready var resume_button: Button = %resume
@onready var quit_button: Button = %quit
"res://Background2 (1).png"
func _ready():
	ui_panel_container.visible = false

func resume():
	get_tree().paused = false
	ui_panel_container.visible = false

func pause():
	get_tree().paused = true
	ui_panel_container.visible = true

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	testEsc()
