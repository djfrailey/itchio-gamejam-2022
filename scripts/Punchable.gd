extends Node2D
class_name Punchable

export var punches_till_death : int = 3

signal punched
signal destroyed

func record_punch():
	punches_till_death -= 1
	print(get_parent().get_name(), " was punched")
	if (punches_till_death <= 0):
		print(get_parent().get_name(), " was destroyed")
		get_parent().queue_free()
