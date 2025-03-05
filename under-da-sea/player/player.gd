extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right","up", "down")
	velocity = direction * SPEED
	move_and_slide()
