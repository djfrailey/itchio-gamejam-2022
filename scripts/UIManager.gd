extends CanvasLayer

class_name UIManager

signal next_button_pressed

onready var TextBubble = $TextBubble
onready var TextBubbleLabel = $TextBubble/Label

var _contents = null
var _current_line : int = 0
var _total_lines : int = 0

func start_conversation(conversation_file : String):
	get_tree().paused = true
	TextBubble.visible = true
	_have_conversation(conversation_file)
	
func stop_conversation():
	TextBubble.visible = false
	TextBubbleLabel.text = ""
	_contents = null
	_current_line = 0
	_total_lines = 0
	yield(VisualServer, "frame_post_draw")
	get_tree().paused = false
	
	
func _read_contents(conversation_file):
	var f : File = File.new()
	var err = f.open(conversation_file, File.READ)
	assert(err == OK, "Could not open conversation file!")
	_contents = f.get_as_text()
	f.close()
	_total_lines = _contents.count("--")
	
func _next_line():
	var line : String = _contents.get_slice("--", _current_line).to_upper()
	if line.empty():
		TextBubbleLabel.text = line
		_current_line += 1
		yield(self, "next_button_pressed")
		_next_line()
	else:
		stop_conversation()
	
func _input(event):
	if (event.is_action_pressed("ui_select") and get_tree().paused):
		emit_signal("next_button_pressed")

func _have_conversation(conversation_file : String):
	_read_contents(conversation_file)
	_next_line()
