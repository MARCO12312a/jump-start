extends CharacterBody2D
var speed: float = 300.0
var acceleration: float = 3000
var friction: float = 1500
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_velocity: float = -300.0
var was_on_floor: bool = true
@onready var stand_collision: CollisionShape2D=$StandCollision
@onready var duck_collision: CollisionShape2D=$DuckCollision
var death_y=600
var alive=true 
var is_ducking=false
var max_tilt: float= 8
var  COYOTE_TIME: float=0.1
var coyote_timer: float=0.0

var jump_buffer_time: float = 0.0
var JUMP_BUFFER_TIME: float = 0.1
func _ready() -> void:
	sprite.play("run")
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	if not alive: 
		return
	if not is_on_floor():
	
		velocity.y += gravity * delta

	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_time = JUMP_BUFFER_TIME
	else:
		jump_buffer_time -= delta
	

	
	if jump_buffer_time > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_time = 0
		coyote_timer = 0
		stretch_sprite()

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	if is_on_floor() and Input.is_action_pressed("s"):
		start_duck()
	else:
		stop_duck()
	velocity.x=0


	move_and_slide()

	check_landing()
	check_death()



func update_tilt(direccion:float)-> void:
	var target_rotation= deg_to_rad(max_tilt)*direccion
	sprite.rotation=lerp(sprite.rotation,target_rotation,0.15)


func check_landing() -> void:
	if is_on_floor() and not was_on_floor:
		squash_land()
		if not is_ducking:
			sprite.play("run")
	was_on_floor = is_on_floor()
		
func stretch_sprite() -> void:
	sprite.scale = Vector2(0.4, 2)
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1),0.15).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)	

func squash_land() -> void:
	sprite.scale = Vector2(2, 0.4)
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1),0.15).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func check_death()-> void:
	if global_position.y>death_y:
		die()

func die() -> void:
	if not alive:
		return
	alive=false
	get_tree().call_deferred("reload_current_scene")

func start_duck():
	if is_ducking:
		return
	is_ducking=true
	stand_collision.disabled=true
	duck_collision.disabled=false
	sprite.play("CROUCH")
func stop_duck():
	if not is_ducking:
		return
	is_ducking=false
	stand_collision.disabled=false
	duck_collision.disabled=true
	if is_on_floor():
		sprite.play("run")