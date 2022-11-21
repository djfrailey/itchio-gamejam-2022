extends KinematicBody2D

class_name Actor

const _WALK_ANIMATION : String = "Walk"
const _PUNCH_ANIMATION : String = "Punch"
const _IDLE_ANIMATION : String = "Idle"

export var _movement_speed : float = 5.0

onready var _sprite : Sprite = $Sprite
onready var _animPlayer : AnimationPlayer = $AnimationPlayer

var _can_move : bool = true # Used to prevent Actor from moving while Punching.
var _targeted_punchable : Punchable = null

func _ready():
	_animPlayer.connect("animation_finished", self, "_on_animPlayer_animation_finished")

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

func _is_walking():
	return _animPlayer.current_animation == _WALK_ANIMATION

func _is_punching():
	return _animPlayer.current_animation == _PUNCH_ANIMATION

func _start_animation(animation : String):
	assert(_animPlayer.has_animation(animation) == true, "Requested animation not present in PlayerController Requested:" + animation)
	if (_animPlayer.current_animation != animation):
		_animPlayer.play(animation)
		_animPlayer.advance(0) # Used in case properties are mutated before the animation is started.
		
func _flip_right():
	_sprite.flip_h = false
		
func _flip_left():
	_sprite.flip_h = true
