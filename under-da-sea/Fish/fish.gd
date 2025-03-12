extends Area2D

@onready var rayfolder = $rayfolder.get_children()

var FishISee := []
var vel := Vector2.ZERO
var speed := 7.0
var screensize : Vector2
var movv := 48

func _ready() -> void:
	screensize = get_viewport_rect().size
	randomize()

func _process(_delta: float) -> void:
	Fish()
	checkCollision()
	vel = vel.normalized() * speed 
	move()
	rotation = lerp_angle(rotation, vel. angle_to_point(Vector2.ZERO), 0.4)

func Fish() -> void:
	if FishISee:
		var _numOffishs := FishISee.size()
		var _avgVel := Vector2.ZERO 
		var _avgPos := Vector2.ZERO
		var _steeraway := Vector2.ZERO

func checkCollision() -> void:
	pass

func move() -> void:
	global_position += vel
	if global_position.x < 0:
		global_position.x = screensize.x
	if global_position.x > screensize.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screensize.y
	if global_position.y > screensize.y:
		global_position.y = 0


func _on_vision_area_exited(area: Area2D) -> void:
	if area:
		FishISee.erase(area)

func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("Fish"):
		FishISee.append(area)
