extends Node2D

@export var num := 100
@export var min := 80
@export var max := 120
@export var prefab : PackedScene 
@export var fishSpawnArea : CollisionShape2D
#@export var spawn_positions : Array = [
#	Vector2(-1, 23),
#	Vector2(140,23),
#	Vector2(140,129),
#	Vector2(-1,129)
#]
@export var SpawnCollisionShape : CollisionShape2D
@export var margin := 80

var screensize = get_viewport_rect().size 
var num_groups = 5
var fish_per_group = 10
var group_radius = 50
var num_fish = 100;

func _process(delta: float) -> void:
	screensize = get_viewport_rect().size
	queue_redraw()

func _ready() -> void:
	num_fish = randi_range(min, max)
	print(num_fish)
	for i in num_fish:
		spawnFish()
	for i in range(num_groups):
		var group_center = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
		for j in range(fish_per_group):
			var random_offset = Vector2(randf_range(-group_radius, group_radius), randf_range(-group_radius, group_radius))
	add_children_at_corners(prefab, get_global_rect(SpawnCollisionShape))
	for i in range(0, 20):
		var object = prefab.instantiate()
		object.global_position = get_spawn_point_global(SpawnCollisionShape)
		add_child(object)
	pass

func spawnFish():
	var fish : Area2D = preload("res://Fish/fish.tscn").instantiate()
	$fishfolder.add_child(fish)
	fish.modulate = Color(randf(), randf(), randf(), 1)
	var rect = fishSpawnArea.shape.get_rect()
	randf_range(rect.position.x, rect.end.x)
	#var xPos = randf_range(0+margin, screensize.x - margin)
	#var yPos = randf_range(0+margin, screensize.y - margin)
	#var spawnPosition = spawn_positions[randi_range(0, spawn_positions.size() - 1	)]
	#fish.global_position = spawnPosition

func _on_timer_timeout() -> void:
	var c := $fishfolder.get_child_count()
	if c < num_fish:
		#print("too few fish :(")
		for i in range(num_fish - c): 
			spawnFish()

func _draw() -> void:
	var start = fishSpawnArea.position - fishSpawnArea.shape.get_rect().size/2
	var end = fishSpawnArea.position - fishSpawnArea.shape.get_rect().size/2
	draw_rect(Rect2(start, end-start), Color.RED, true)
#func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#if area.is_in_group("Fish"):

func get_spawn_point_global(collisionShape: CollisionShape2D) -> Vector2:
	var fishSpawnAreaRect = get_global_rect(collisionShape)
	var xPos = randf_range(fishSpawnAreaRect.position.x, fishSpawnAreaRect.end.x)
	var yPos = randf_range(fishSpawnAreaRect.position.y, fishSpawnAreaRect.end.y)
	return Vector2(xPos, yPos)

func get_global_rect(collisionShape: CollisionShape2D) -> Rect2:
	var shapeRect = collisionShape.shape.get_rect()
	var global_pos = collisionShape.to_global(shapeRect.position)
	var global_end =  collisionShape.to_global(shapeRect.end)
	return Rect2(global_pos, global_end - global_pos)

func add_children_at_corners(scene:PackedScene, rect:Rect2) -> void:
	var TL = scene.instantiate()
	change_color(TL, Color.RED)
	TL.global_position = rect.position
	var BL = scene.instantiate()
	change_color(BL, Color.BLUE)
	BL.global_position = rect.position
	var TR = scene.instantiate()
	change_color(TR, Color.GREEN)
	TR.global_position = rect.position
	var BR = scene.instantiate()
	change_color(BR, Color.MAGENTA)
	BR.global_position = rect.end
	add_child(TL)
	add_child(BL)
	add_child(TR)
	add_child(BR)
	pass

func change_color(object: CanvasItem, color: Color) -> void:
	object.modulate = color
	pass
