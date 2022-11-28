extends Area2D

class_name ConversationTrigger

export(String, FILE, "*.txt") var conversation_file
export(NodePath) var ui_manager_node_path

onready var UIController : UIManager = get_node(ui_manager_node_path)

func _on_ConversationTrigger_body_entered(body):
	if body as PlayerController:
		yield(body.get_node("AnimationPlayer"), "animation_finished")
		UIController.start_conversation(conversation_file)
		queue_free()
