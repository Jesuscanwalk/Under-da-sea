class_name Mob extends CharacterBody2D

@export var max_speed := 250.0
@export var acceleration := 700.0
@onready var player: Player = $"../Player"

var _player: Player = null
var damage := 1

@onready var detection_area: Area2D = %DetectionArea
@onready var hitbox: Area2D = $Hitbox
@onready var damage_timer: Timer = $DamageTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	detection_area.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			animated_sprite_2d.play("swim")
			_player = body
			animated_sprite_2d.flip_h = true
	)
	detection_area.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_player = null
	)
	hitbox.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.current_health -= damage
			damage_timer.start()
			)
	hitbox.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			damage_timer.stop()
			)
	damage_timer.timeout.connect(func () -> void:
		_player.current_health -= damage
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
	look_at(player.position)
