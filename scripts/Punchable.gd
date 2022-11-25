extends Node2D
class_name Punchable

export var punches_till_death : int = 3

signal punched
signal destroyed

func record_punch():
	punches_till_death -= 1
	if (punches_till_death <= 0):
		emit_signal('destroyed')
	else:
		emit_signal('punched')
