extends KinematicBody2D

const _WALK_ANIMATION : String = "Walk"
const _PUNCH_ANIMATION : String = "Punch"
const _IDLE_ANIMATION : String = "Idle"

onready var _animPlayer : AnimationPlayer = $AnimationPlayer
onready var _sprite : Sprite = $Sprite

var _can_move : bool = true # Used to prevent Player from moving while Punching.

## OVERRIDES

func _process(delta):
	if (_can_move):
		_handle_movement(delta)
	
	if (_is_idle()):
		_start_animation(_IDLE_ANIMATION)
		
		
## PUBLIC METHODS

## PRIVATE METHODS

func _handle_movement(delta):
	if (Input.is_action_pressed("ui_right")):
		_sprite.flip_h = false
		_start_animation(_WALK_ANIMATION)
	elif (Input.is_action_pressed("ui_left")):
		_sprite.flip_h = true
		_start_animation(_WALK_ANIMATION)
		
func _is_idle():
	return Input.is_action_pressed("ui_right") == false and Input.is_action_pressed("ui_left") == false and Input.is_action_pressed("ui_select") == false

func _start_animation(animation : String):
	assert(_animPlayer.has_animation(animation) == true, "Requested animation not present in PlayerController Requested:" + animation)
	
	if (_animPlayer.current_animation != animation):
		_animPlayer.play(animation)
