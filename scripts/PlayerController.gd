extends Actor

onready var _camera : Camera2D = $Camera2D

## OVERRIDES

func _physics_process(delta):
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
	._flip_right()
	if (_camera.offset_h < 0):
		_camera.offset_h = -1 * _camera.offset_h
		
func _flip_left():
	._flip_left()
	if (_camera.offset_h > 0):
		_camera.offset_h = -1 * _camera.offset_h
