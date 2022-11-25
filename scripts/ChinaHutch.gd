extends Area2D

class_name ChinaHutch

func _on_Punchable_destroyed():
	queue_free()

func _on_Punchable_punched():
	$Particles2D.restart()
	$Particles2D.emitting = true
