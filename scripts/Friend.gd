extends ConversationTrigger

func _on_Friend_body_entered(body):
	if body as PlayerController:
		yield(body.get_node("AnimationPlayer"), "animation_finished")
		UIController.connect("conversation_ended", self, "_on_UIManager_conversation_ended")
		UIController.start_conversation(conversation_file)

func _on_UIManager_conversation_ended(conversation):
	if (conversation == conversation_file.get_file()):
		get_tree().change_scene("res://scenes/MainMenu.tscn")
