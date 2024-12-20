extends CharacterBody2D

class_name BaseCharacter

var wood: int = 1
var _can_attack: bool = true
var _attack_animation_name: String = ""

@export_category("Variables")
@export var _move_speed: float = 128.0
@export var _left_attack_name: String = ""
@export var _right_attack_name: String = ""
@export var _min_attack: int = 1
@export var _max_attack: int = 5

@export_category("Objects")
@export var _sprite2D: Sprite2D
@export var _animation: AnimationPlayer
@export var _attack_area_collision: CollisionShape2D


func _physics_process(_delta: float) -> void:
	_move()
	_attack()	
	_animate()
	
func _move() -> void:
	var _direction: Vector2 = Input.get_vector(
	"move_left", "move_right", "move_up", "move_down"
	)
	velocity = _direction * _move_speed
	move_and_slide()

func _attack()	-> void:
	if Input.is_action_just_pressed("left_attack") and _can_attack:
		_can_attack = false
		_attack_animation_name = _left_attack_name
		set_physics_process(false)
		
		
	if Input.is_action_just_pressed("right_attack") and _can_attack:
		_can_attack = false
		_attack_animation_name = _right_attack_name
		set_physics_process(false)
		
	
func _animate() -> void:	
	if velocity.x > 0:
		_sprite2D.flip_h = false
		_attack_area_collision.position.x = 64
		
	if velocity.x < 0:
		_sprite2D.flip_h = true
		_attack_area_collision.position.x = -64
	if _can_attack == false:
		_animation.play(_attack_animation_name)
		return
		
	if velocity:
		_animation.play("run")
		return
		
	_animation.play("idle")


func _on_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "attack_axe" or _anim_name == "attack_hammer":
		_can_attack = true
		set_physics_process(true)

func update_collision_layer_mask(_type: String) -> void:
	if _type == "in":
		pass


func _on_attack_area_body_entered(_body: Node2D) -> void:
	if (
		_body is PhysicsTree or 
		_body is Warrior
		):
		_body.update_health([_min_attack, _max_attack])
