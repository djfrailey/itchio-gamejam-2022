extends Node2D
class_name Punchable

export var punches_till_death : int = 3

onready var max_punches_till_death : int = punches_till_death

signal punched
signal destroyed

func record_punch():
	punches_till_death -= 1
	if (punches_till_death <= 0):
		emit_signal('destroyed')
	else:
		emit_signal('punched')

func increase_punches_till_death(amount : int):
	punches_till_death += amount
	
	if (punches_till_death > max_punches_till_death):
		punches_till_death = max_punches_till_death
