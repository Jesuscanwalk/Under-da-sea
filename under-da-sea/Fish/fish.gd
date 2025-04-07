extends Area2D

@onready var rayfolder = $rayfolder.get_children()
var FishISee := []
var max_speed = 10
var vel := Vector2.ZERO
var speed := 5.0
@onready var screensize = get_viewport_rect().size 
var movv := 48
var direction = Vector2(0, 1)
var seperation_distance = 70.0
var global_direction := Vector2(1, 0)
var cohesion_weight := 0.005
var alignment_weight := 0.05
var separation_weight := 1.5
var direction_influence := 0.02
var drift_strength := 0.1
var min_separation_distance := 10.0

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
		for Fish in FishISee:
			_avgVel += Fish.vel
			_avgPos += Fish.position
			var distance_to_fish = (Fish.global_position - global_position).length()
			if distance_to_fish < seperation_distance and distance_to_fish > 0.01:
				_steeraway -= (Fish.global_position - global_position).normalized() / distance_to_fish
		_avgVel /= _numOffishs
		_avgPos /= _numOffishs
		vel += (_avgVel - vel) * alignment_weight
		vel += (_avgPos - position) * cohesion_weight
		if _steeraway != Vector2.ZERO:
			_steeraway = _steeraway.normalized()
		vel += _steeraway * separation_weight
	vel += (global_direction - vel.normalized()) * direction_influence
	vel += Vector2(randf_range(-drift_strength, drift_strength), randf_range(-drift_strength, drift_strength))

func checkCollision() -> void:
	for ray in rayfolder:
		var r: RayCast2D = ray
		if r.is_colliding():
			var collider = r.get_collider()
			if r.get_collider().is_in_group("blocks"):
				var magi := 100/ (r.get_collision_point() - global_position).length_squared()
				vel -= (r.cast_to.rotated(rotation) * magi)


func move() -> void:
	global_position += vel
	if global_position.x < 0:
		global_position.x = screensize.x
	elif global_position.x > screensize.x:
		global_position.x = 0
		if global_position.y < 0:
			global_position.y = screensize.y
		elif global_position.y > screensize.y:
				global_position.y = 0

func _on_vision_area_exited(area: Area2D) -> void:
	if area and area in FishISee:
		FishISee.erase(area)

func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("Fish"):
		FishISee.append(area)


func _on_body_entered(body: Node2D) -> void:
	queue_free()
