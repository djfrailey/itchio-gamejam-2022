extends KinematicBody2D

const _WALK_ANIMATION : String = "Walk"
const _PUNCH_ANIMATION : String = "Punch"
const _IDLE_ANIMATION : String = "Idle"

onready var _animPlayer : AnimationPlayer = $AnimationPlayer
onready var _sprite : Sprite = $Sprite

var _can_move : bool = true # Used to prevent Player from moving while Punching.

## OVERRIDES

func _ready():
	_animPlayer.connect("animation_finished", self, "_on_animPlayer_animation_finished")

func _process(delta):
	if (_can_move):
		_handle_movement(delta)
		
	_handle_punch()
	
	if (_animPlayer.current_animation == ""):
		_can_move = true
		_start_animation(_IDLE_ANIMATION)

## PUBLIC METHODS

## PRIVATE METHODS

func _on_animPlayer_animation_finished(anim_name : String):
	if (anim_name == _PUNCH_ANIMATION):
		_start_animation(_IDLE_ANIMATION)

func _handle_punch():
	if (Input.is_action_just_pressed("ui_select")):
		_start_animation(_PUNCH_ANIMATION)
		_can_move = false

func _handle_movement(delta):
	if (Input.is_action_pressed("ui_right")):
		_sprite.flip_h = false
		_start_animation(_WALK_ANIMATION)
	elif (Input.is_action_pressed("ui_left")):
		_sprite.flip_h = true
		_start_animation(_WALK_ANIMATION)

func _start_animation(animation : String):
	assert(_animPlayer.has_animation(animation) == true, "Requested animation not present in PlayerController Requested:" + animation)
	if (_animPlayer.current_animation != animation):
		_animPlayer.play(animation)
		_animPlayer.advance(0) # Used in case properties are mutated before the animation is started.
