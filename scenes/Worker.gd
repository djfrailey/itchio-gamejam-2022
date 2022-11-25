extends Actor

onready var _visionDetector : RayCast2D = $RayCast2D

# Maybe move this to a state machine if we have time
const _STATE_WALKING : int = 1
const _STATE_ATTACKING : int = 2

var state : int = _STATE_WALKING

func _ready():

	# Make sure we aren't reporting collisions for the Hutch's
	for hutch in get_tree().get_nodes_in_group("ChinaHutch"):
		_visionDetector.add_exception(hutch)

func _physics_process(delta):
	if (_visionDetector.is_colliding()):
		var collision = _visionDetector.get_collider()
		print(collision)
	elif (!_is_punching()):
		var collision : KinematicCollision2D = _walk(delta)
		
		if (collision):
			if (collision.collider.get_groups().has("ChinaHutch")):
				_flip()
				
func _flip():
	if (_sprite.flip_h == true):
		_flip_right()
	else:
		_flip_left()
		
func _flip_right():
	._flip_right()
	_visionDetector.cast_to.x = -1 * _visionDetector.cast_to.x
	
func _flip_left():
	._flip_left()
	_visionDetector.cast_to.x = -1 * _visionDetector.cast_to.x

func _walk(delta):
	var velocity = Vector2()
	
	if (_sprite.flip_h == false):
		# Facing right
		velocity.x = _movement_speed
	else:
		velocity.x = -1 * _movement_speed
	
	_start_animation(_WALK_ANIMATION)
	return move_and_collide(velocity * delta)
