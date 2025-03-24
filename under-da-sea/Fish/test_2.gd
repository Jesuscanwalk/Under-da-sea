extends Node2D

@export var num := 100
@export var margin := 100
var screensize : Vector2 

func _ready() -> void:
	screensize = get_viewport_rect().size
	randomize()
	for i in num:
		spawnFish()


func spawnFish():
	var fish : Area2D = preload("res://Fish/fish.tscn").instantiate()
	$fishfolder.add_child(fish)
	fish.modulate = Color(randf(), randf(), randf(), 1)
	fish.global_position = Vector2( (randf_range(0+margin, screensize.x - margin)), (randf_range(0+margin, screensize.y - margin)) )


func _on_timer_timeout() -> void:
	var c := $fishfolder.get_child_count()
	if c < num:
		print("too few fish :(")
		for i in floor(num-c): 
			spawnFish()
