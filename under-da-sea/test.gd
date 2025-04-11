extends Node2D

@export var num := 100
@export var min := 80
@export var max := 120

@export var margin := 100
var screensize = get_viewport_rect().size 
var num_groups = 5
var fish_per_group = 10
var group_radius = 50
var num_fish = 100;

func _process(delta: float) -> void:
	screensize = get_viewport_rect().size
func _ready() -> void:
	num_fish = randi_range(min, max)
	print(num_fish)
	for i in num_fish:
		spawnFish()
	for i in range(num_groups):
		var group_center = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
		for j in range(fish_per_group):
			var random_offset = Vector2(randf_range(-group_radius, group_radius), randf_range(-group_radius, group_radius))

func spawnFish():
	var fish : Area2D = preload("res://Fish/fish.tscn").instantiate()
	$fishfolder.add_child(fish)
	fish.modulate = Color(randf(), randf(), randf(), 1)
	fish.global_position = Vector2( (randf_range(0+margin, screensize.x - margin)), (randf_range(0+margin, screensize.y - margin)) )


func _on_timer_timeout() -> void:
	var c := $fishfolder.get_child_count()
	if c < num_fish:
		#print("too few fish :(")
		for i in range(num_fish - c): 
			spawnFish()
