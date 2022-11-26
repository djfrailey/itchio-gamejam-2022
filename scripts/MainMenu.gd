extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Level.tscn")


func _on_ExitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
