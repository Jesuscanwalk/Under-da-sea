extends Area2D

const SEPARATION_WEIGHT = 0.5
const ALIGNMENT_WEIGHT = 0.5
const COHESION_WEIGHT = 0.1


var max_speed = 2
var speed = 2
var direction = Vector2(0, 1)
var separation_distance = 20

var _local_flockmates = []


func _physics_process(_delta):
	self.rotation = Vector2(0, 1).angle_to(direction)
	var collision = self.move_and_slide(direction * speed)
	if collision:
		if collision.collider is TileMap:
			direction = _collision_reaction_direction(collision)
	else:
		direction = _flock_direction()


func _collision_reaction_direction(collision):
	return (collision.position - collision.normal).direction_to(self.position)


func _flock_direction():
	var separation = Vector2()
	var heading = direction
	var cohesion = Vector2()

	for flockmate in _local_flockmates:
		heading += flockmate.get_direction()
		cohesion += flockmate.position

		var distance = self.position.distance_to(flockmate.position)

		if distance < separation_distance:
			separation -= (flockmate.position - self.position).normalized() * (separation_distance / distance * speed)

	if _local_flockmates.size() > 0:
		heading /= _local_flockmates.size()
		cohesion /= _local_flockmates.size()
		var center_direction = self.position.direction_to(cohesion)
		var center_speed = max_speed * self.position.distance_to(cohesion) / $detection_radius/CollisionShape2D.shape.radius
		cohesion = center_direction * center_speed

	return (
		direction +
		separation * SEPARATION_WEIGHT +
		heading * ALIGNMENT_WEIGHT +
		cohesion * COHESION_WEIGHT
	).clamped(max_speed)


func get_direction():
	return direction


func set_direction(direction):
	direction = direction


func _on_detection_radius_body_entered(body):
	if body == self:
		return

	if body.is_in_group("Fish"):
		_local_flockmates.push_back(body)


func _on_detection_radius_body_exited(body):
	if body.is_in_group("Fish"):
		_local_flockmates.erase(body)
