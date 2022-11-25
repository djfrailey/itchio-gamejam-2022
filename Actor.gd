extends KinematicBody2D

class_name Actor

const _WALK_ANIMATION : String = "Walk"
const _PUNCH_ANIMATION : String = "Punch"
const _IDLE_ANIMATION : String = "Idle"

const _MOVE_RIGHT : int = 0
const _MOVE_LEFT : int = 1

export var _movement_speed : float = 5.0

onready var _sprite : Sprite = $Sprite
onready var _animPlayer : AnimationPlayer = $AnimationPlayer
onready var _punchCollider : Area2D = $PunchCollider

var _can_move : bool = true # Used to prevent Actor from moving while Punching.
var _movement_direction : int = _MOVE_RIGHT

func _ready():
	print(self.get_name(), " animation connected")
	_animPlayer.connect("animation_finished", self, "_on_animPlayer_animation_finished")

func _on_animPlayer_animation_finished(anim_name : String):
	# Dirty hack since I didn't add a third frame for the punch animation :(
	if (anim_name == _PUNCH_ANIMATION):
		_start_animation(_IDLE_ANIMATION)
		_record_punchables()
		
func _record_punchables():
	# Might be better off keeping track of a list of "Punchables"
	# and using signals [DJF]
	for area in $PunchCollider.get_overlapping_areas():
		if (area.has_node("Punchable") and $PunchCollider.overlaps_area(area)):
			area.get_node("Punchable").record_punch()
			
	for body in $PunchCollider.get_overlapping_bodies():
		if (body.has_node("Punchable") and $PunchCollider.overlaps_body(body)):
			body.get_node("Punchable").record_punch()
			
func _handle_punch():
	_start_animation(_PUNCH_ANIMATION)
	_can_move = false

func _is_walking():
	return _animPlayer.current_animation == _WALK_ANIMATION

func _is_punching():
	return _animPlayer.current_animation == _PUNCH_ANIMATION

func _start_animation(animation : String):
	assert(_animPlayer.has_animation(animation) == true, "Requested animation not present in Actor Requested:" + animation)
	if (_animPlayer.current_animation != animation):
		_animPlayer.play(animation)
		_animPlayer.advance(0) # Used in case properties are mutated before the animation is started.
		
func _set_move_direction(direction : int) -> void:
	_movement_direction = direction

func _is_walking_right() -> bool:
	return _movement_direction == _MOVE_RIGHT

func _is_walking_left() -> bool:
	return _movement_direction == _MOVE_LEFT

func _flip():
	scale.x = -1 * scale.x
