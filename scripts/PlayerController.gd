extends Actor

class_name PlayerController

export(NodePath) var ui_manager_node_path

onready var _camera : Camera2D = $Camera2D
onready var UIController : UIManager = get_node(ui_manager_node_path)
onready var PunchableComponent : Punchable = get_node("Punchable")

func _ready():
	._ready()
	UIController.set_player_max_health(PunchableComponent.punches_till_death)
	UIController.set_player_health(PunchableComponent.punches_till_death)

func _process(delta):
	if (_can_move):
		_handle_movement(delta)
		
	_handle_punch()
	
	if (_animPlayer.current_animation == ""):
		_can_move = true
		_start_animation(_IDLE_ANIMATION)
		
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


func _on_Punchable_punched():
	UIController.set_player_health(PunchableComponent.punches_till_death)

func _on_Punchable_destroyed():
	UIController.connect("conversation_ended", self, "_on_UIController_conversation_ended")
	UIController.start_conversation("res://assets/conversations/death.txt")

func _on_UIController_conversation_ended(conversation):
	if (conversation == "death.txt"):
		# This is in a few places and should be moved to a
		# singleton
		get_tree().change_scene("res://scenes/MainMenu.tscn")

func add_health(amount : int):
	PunchableComponent.increase_punches_till_death(amount)
	UIController.set_player_health(PunchableComponent.punches_till_death)
