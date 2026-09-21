extends Node2D
@export var chunk_scene: PackedScene
@export var chunk_width: float = 200
@export var gap_chance: float= 0.25
@export var chunks_ahead: int = 6

var player= Node2D
var spawned_chunks: Array[Node2D]=[]
var nextspawnx: float=0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	for i in chunks_ahead:
		try_spawn_chunk()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while player.global_position.x+1000> nextspawnx:
		try_spawn_chunk()
	clean_up()
func try_spawn_chunk():
	if randf()>gap_chance:
		var chunk: Node2D=chunk_scene.instantiate()
		chunk.global_position=Vector2(nextspawnx,0)
		add_child(chunk)
		spawned_chunks.append(chunk)
	nextspawnx+=chunk_width


func clean_up():
	for chunk in spawned_chunks.duplicate():
		if chunk.global_position.x < player.global_position.x-1200:
			chunk.queue_free()
			spawned_chunks.erase(chunk)
