extends CharacterBody2D

class_name Warrior

const _SKULL_COLLECTABLE: PackedScene = preload("res://Collectables/skull.tscn")

var _is_dead: bool = false
var _health: int
var _diretion: Vector2
var _wait_timer: float
var _run_wait_timer: float
var _regular_move_speed: float

@export_category("Variables")
@export var _move_speed: float=128
@export var _min_health: int = 6
@export var _max_health: int = 20
@export var _min_skull: int = 1
@export var _max_skull: int = 6

@export_category("Objetcs")
@export var _sprite: Sprite2D
@export var _animation: AnimationPlayer
@export var _walk_timer: Timer
@export var _run_timer: Timer

func _ready() -> void:
	_regular_move_speed = _move_speed
	_health = randi_range(_min_health, _max_health)
	
	_wait_timer = randf_range(4.0,20.0)
	_run_wait_timer = randf_range(1.0,3.1)
	
	_diretion = _get_direction()
	_walk_timer.start(_wait_timer)
	
func _physics_process(_delta: float) -> void:
	velocity = _diretion * _move_speed
	move_and_slide()
	if get_slide_collision_count() > 0:
		_diretion = velocity.bounce(
			get_slide_collision(0).get_normal()
		).normalized()
	_animate()
	
func update_health(_damage_range: Array) -> void: 
	if _is_dead:
		return
	
	_health -= randi_range(
		_damage_range[0],
		_damage_range[1]
	)
	if _health <= 0:
		_spawn_skull()
		_is_dead = true
		queue_free()
		return
	_diretion = _get_direction()
	_move_speed *= 2
	_run_timer.start(_run_wait_timer)
		
func _spawn_skull() -> void:
	var _skull_amount: int = randi_range(_min_skull, _max_skull)
	for _i in _skull_amount:
		var _skull: CollectableComponent = _SKULL_COLLECTABLE.instantiate()
		_skull.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
			
		get_tree().root.call_deferred("add_child", _skull)
	
func _get_direction() -> Vector2:
	return [
		Vector2(-1,0), Vector2 (1,0), Vector2(-1, -1), Vector2(0,-1),
		Vector2(1,-1), Vector2(-1,1), Vector2(0,1), Vector2(1,1),
		Vector2.ZERO
	].pick_random()
	
func _animate() -> void:
	if velocity.x > 0:
		_sprite.flip_h = false
	if velocity.x < 0:
		_sprite.flip_h = false
	if velocity:
		_animation.play("walk")
		return
	_animation.play("idle")
		


func _on_walk_timer_timeout() -> void:
	if _diretion == Vector2.ZERO:
		_diretion = _get_direction()
		return
	_diretion = Vector2.ZERO


func _on_run_timer_timeout() -> void:
	_move_speed = _regular_move_speed
