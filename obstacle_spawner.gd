extends Node2D
@export var obstacle_scene: Array[PackedScene]=[]
@export var spawn_x: float=300
@export var ground_y: float=55
@export var initial_speed: float= 300
@export var speed_increase_per_second= 5
@export var min_spawn_interval: float=0.6
@export var max_spawn_interval: float= 1.4

var current_speed: float
var spawn_timer: float=0.0
var time_alive: float=0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_speed=initial_speed
	spawn_timer=randf_range(min_spawn_interval,max_spawn_interval)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_alive+=delta
	current_speed=initial_speed+speed_increase_per_second*time_alive
	spawn_timer-=delta
	if spawn_timer<=0:
		spawn_obstacle()
		spawn_timer=randf_range(min_spawn_interval,max_spawn_interval)

func spawn_obstacle():
	var scene: PackedScene=obstacle_scene[randi() % obstacle_scene.size()]
	var obstacle = scene.instantiate()
	obstacle.global_position=Vector2(spawn_x,ground_y-obstacle.height_offset)
	obstacle.speed=current_speed
	add_child(obstacle)

	
