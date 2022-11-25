extends Actor

class_name PlayerController

onready var _camera : Camera2D = $Camera2D

## OVERRIDES

func _process(delta):
	if (_can_move):
		_handle_movement(delta)
		
	_handle_punch()
	
	if (_animPlayer.current_animation == ""):
		_can_move = true
		_start_animation(_IDLE_ANIMATION)
		
## SIGNAL HANDLERS
		
## PUBLIC METHODS

## PRIVATE METHODS

func _handle_punch():
	if (Input.is_action_just_pressed("ui_select")):
		._handle_punch()

func _handle_movement(delta):
	var velocity = Vector2()
	
	if (Input.is_action_pressed("ui_right")):
		if (_is_walking_left()):
			_set_move_direction(_MOVE_RIGHT)
			_flip()
		_start_animation(_WALK_ANIMATION)
		velocity.x = _movement_speed
	elif (Input.is_action_pressed("ui_left")):
		if (_is_walking_right()):
			_set_move_direction(_MOVE_LEFT)
			_flip()
		_start_animation(_WALK_ANIMATION)
		velocity.x = -1 * _movement_speed
	
	if (_is_walking() and (Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"))):
		_start_animation(_IDLE_ANIMATION)
	
	if (_is_walking()):
		move_and_collide(velocity * delta)
