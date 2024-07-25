class_name DialogueManager
extends Node

const DIALOGUE_SCENE := preload("res://Scenes/Dialogue.tscn")

signal message_requested()
signal message_completed()
signal finished

var _messages = []
var _active_dialogue_offset = 0
var _is_active = false
var cur_dialogue_instance: Control  # Cambiado a Control para una mayor flexibilidad

func show_messages(message_list: Array, position: Vector2) -> void:
	if _is_active:
		return

	_is_active = true
	_messages = message_list
	_active_dialogue_offset = 0
	
	var _dialogue = DIALOGUE_SCENE.instantiate() as Control
	
	if _dialogue == null:
		print("Failed to instantiate dialogue scene. Please check the scene path and ensure it is valid.")
		_is_active = false
		return
	
	if not _dialogue.has_method("update_message") or not _dialogue.has_signal("message_completed"):
		print("The instantiated scene does not have the expected methods or signals.")
		_is_active = false
		return
	
	_dialogue.connect(
		"message_completed",
		Callable(self, "_on_message_completed")
	)
	
	get_tree().get_root().add_child(_dialogue)
	
	_dialogue.rect_global_position = position

	
	cur_dialogue_instance = _dialogue
	
	_show_current()

func _show_current() -> void:
	if cur_dialogue_instance == null:
		print("Current dialogue instance is null.")
		return
	
	emit_signal("message_requested")
	var _msg = _messages[_active_dialogue_offset] as String
	cur_dialogue_instance.update_message(_msg)  # Asume que update_message es un método en el script adjunto al nodo raíz

func _input(event):
	if (
		event.is_pressed() and 
		!event.is_echo() and
		event is InputEventKey and
		(event as InputEventKey).scancode == KEY_ENTER and
		_is_active and
		cur_dialogue_instance.message_is_fully_visible()  # Verifica si el mensaje está completamente visible
	):
		if _active_dialogue_offset < _messages.size() - 1:
			_active_dialogue_offset += 1
			_show_current()
		else:
			_hide() 

func _hide() -> void:
	if cur_dialogue_instance == null:
		return
		
	cur_dialogue_instance.disconnect(
		"message_completed", Callable(self, "_on_message_completed")
	)
	cur_dialogue_instance.queue_free()
	cur_dialogue_instance = null
	_is_active = false
	emit_signal("finished")

func _on_message_completed() -> void:
	emit_signal("message_completed")
