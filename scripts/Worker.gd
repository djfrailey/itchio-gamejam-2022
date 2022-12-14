extends Actor

onready var _visionDetector : RayCast2D = $RayCast2D
onready var _PunchCollider : Area2D = $PunchCollider

# Maybe move this to a state machine if we have time
const _STATE_WALKING : int = 1
const _STATE_ATTACKING : int = 2

var _state : int = _STATE_WALKING
var _colliding_with_player : bool = false
var _can_punch = true

func _process(delta):
	if (_visionDetector.is_colliding()):
		var collision = _visionDetector.get_collider()
		if (collision as PlayerController):
			_state = _STATE_ATTACKING
	else:
		_state = _STATE_WALKING
	
	if (_colliding_with_player and !_is_punching() and _can_punch):
		_can_punch = false
		_handle_punch()
	
	if (!_is_punching() and !_colliding_with_player):
		_walk(delta)

func _handle_punch():
	._handle_punch()
	yield(get_tree().create_timer(0.65), "timeout")
	_can_punch = true

func _walk(delta):
	var velocity = Vector2()
	
	if (_is_walking_right()):
		velocity.x = _movement_speed
	else:
		velocity.x = -1 * _movement_speed
	
	_start_animation(_WALK_ANIMATION)
	move_and_collide(velocity * delta)
	
func _change_walk_direction() -> void:
	if (_is_walking_right()):
		_set_move_direction(_MOVE_LEFT)
	else:
		_set_move_direction(_MOVE_RIGHT)
		
	_flip()

func _on_AreaCollider_area_entered(area):
	if ((area as ChinaHutch or area as TileMap) and _state == _STATE_WALKING):
		_change_walk_direction()


func _on_PunchCollider_body_entered(body):
	if (body.get_name() == "Bull" and _STATE_ATTACKING):
		_colliding_with_player = true
		
	if (body as TileMap):
		_change_walk_direction()

func _on_PunchCollider_body_exited(body):
	if (body.get_name() == "Bull" and _STATE_ATTACKING):
		_colliding_with_player = false
		_start_animation(_IDLE_ANIMATION)


func _on_Punchable_destroyed():
	queue_free()
