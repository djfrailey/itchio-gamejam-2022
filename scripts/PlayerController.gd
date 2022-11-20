extends KinematicBody2D

const _WALK_ANIMATION : String = "Walk"
const _PUNCH_ANIMATION : String = "Punch"
const _IDLE_ANIMATION : String = "Idle"

export var _movement_speed : float = 5.0

onready var _animPlayer : AnimationPlayer = $AnimationPlayer
onready var _sprite : Sprite = $Sprite
onready var _camera : Camera2D = $Camera2D

var _can_move : bool = true # Used to prevent Player from moving while Punching.
var _targeted_punchable : Punchable = null

## OVERRIDES

func _ready():
	_animPlayer.connect("animation_finished", self, "_on_animPlayer_animation_finished")

func _physics_process(delta):
	if (_can_move):
		_handle_movement(delta)
		
	_handle_punch()
	
	if (_animPlayer.current_animation == ""):
		_can_move = true
		_start_animation(_IDLE_ANIMATION)
		
## SIGNAL HANDLERS

func _on_animPlayer_animation_finished(anim_name : String):
	# Dirty hack since I didn't add a third frame for the punch animation :(
	if (anim_name == _PUNCH_ANIMATION):
		_start_animation(_IDLE_ANIMATION)
		if (_targeted_punchable):
			_targeted_punchable.record_punch()

func _on_PunchCollider_body_entered(body):
	if (body.has_node("Punchable")):
		_targeted_punchable = body.get_node("Punchable")
		
func _on_PunchCollider_body_exited(body):
	_targeted_punchable = null
		
## PUBLIC METHODS

## PRIVATE METHODS

func _handle_punch():
	if (Input.is_action_just_pressed("ui_select")):
		_start_animation(_PUNCH_ANIMATION)
		_can_move = false

func _handle_movement(delta):
	var velocity = Vector2()
	
	if (Input.is_action_pressed("ui_right")):
		_flip_right()
		_start_animation(_WALK_ANIMATION)
		velocity.x = _movement_speed
	elif (Input.is_action_pressed("ui_left")):
		_flip_left()
		_start_animation(_WALK_ANIMATION)
		velocity.x = -1 * _movement_speed
	
	if (_is_walking() and (Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"))):
		_animPlayer.stop()
	
	if (_is_walking()):
		move_and_collide(velocity * delta)

func _flip_right():
	_sprite.flip_h = false
	if (_camera.offset_h < 0):
		_camera.offset_h = -1 * _camera.offset_h
		
func _flip_left():
	_sprite.flip_h = true
	if (_camera.offset_h > 0):
		_camera.offset_h = -1 * _camera.offset_h

func _is_walking():
	return _animPlayer.current_animation == _WALK_ANIMATION

func _is_punching():
	return _animPlayer.current_animation == _PUNCH_ANIMATION

func _start_animation(animation : String):
	assert(_animPlayer.has_animation(animation) == true, "Requested animation not present in PlayerController Requested:" + animation)
	if (_animPlayer.current_animation != animation):
		_animPlayer.play(animation)
		_animPlayer.advance(0) # Used in case properties are mutated before the animation is started.
