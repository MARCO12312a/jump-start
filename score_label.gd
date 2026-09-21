extends Label

var spawner: Node2D
var distance: float=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner=get_tree().get_first_node_in_group("spawner")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not spawner:
		return
	distance+=spawner.current_speed*delta*0.1
	text= "Puntaje: %d" % int(distance)
