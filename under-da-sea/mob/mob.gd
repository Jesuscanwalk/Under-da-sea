class_name Mob extends CharacterBody2D

@export var max_speed := 250.0
@export var acceleration := 700.0

var _player: Player = null
var damage := 1

@onready var detection_area: Area2D = %DetectionArea
@onready var hitbox: Area2D = $Hitbox
@onready var damage_timer: Timer = $DamageTimer


func _ready() -> void:
	detection_area.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_player = body
	)
	detection_area.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_player = null
	)

func _physics_process(delta: float) -> void:
	if _player == null:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	else:
		var direction := global_position.direction_to(_player.global_position)
		var distance := global_position.distance_to(_player.global_position)
		var speed := max_speed if distance > 120.0 else max_speed * distance / 120.0
		var desired_velocity := direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)

	move_and_slide()
