extends Node2D

@onready var HeartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $Player
@export var num := 100
@export var _min := 80
@export var _max := 120
@export var prefab : PackedScene 
@export var fishSpawnArea : CollisionShape2D
@export var SpawnCollisionShape : CollisionShape2D
@export var margin := 80
var screensize = get_viewport_rect().size 
var num_groups = 5
var fish_per_group = 10
var group_radius = 50
var num_fish = 100;

func _process(_delta: float) -> void:
	#screensize = get_viewport_rect().size
	queue_redraw()

func _ready() -> void:
	num_fish = randi_range(_min, _max)
	print(num_fish)
	for i in num_fish:
		spawnFish()
	for i in range(num_groups):
		var _group_center = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
		for j in range(fish_per_group):
			var _random_offset = Vector2(randf_range(-group_radius, group_radius), randf_range(-group_radius, group_radius))
	pass

	HeartsContainer.setMaxHearts(player.max_health)
	HeartsContainer.updateHearts(player.current_health)
	player.health_changed.connect(HeartsContainer.updateHearts)

func spawnFish():
	var fish : Area2D = preload("res://Fish/fish.tscn").instantiate()
	$fishfolder.add_child(fish)
	fish.modulate = Color(randf(), randf(), randf(), 1)
	fish.global_position = get_spawn_point_global(fishSpawnArea)


func _on_timer_timeout() -> void:
	var current_fish_count := $fishfolder.get_child_count()
	print("timeout with " + str(current_fish_count) + " fish, desired is: " + str(num_fish))
	if current_fish_count < num_fish:
		for i in range(num_fish - current_fish_count): 
			spawnFish()
	pass

func _draw() -> void:
	var start = fishSpawnArea.position - fishSpawnArea.shape.get_rect().size/2
	var end = fishSpawnArea.position - fishSpawnArea.shape.get_rect().size/2
	draw_rect(Rect2(start, end-start), Color.RED, true)


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


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Fish"):
		#print("Fish.exited:", area.name)
		area.queue_free()
