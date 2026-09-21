extends Area2D
@export var height_offset: float=0.0
var speed: float=300

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	global_position.x-=speed*delta
	if global_position.x<-200:
		queue_free()

func _on_body_entered(body:Node2D)->void:
	if body.is_in_group("player"):
		body.die()
