@tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/dialogueplugin/DialogueEditor.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BR,dock)
	

func _exit_tree():
	dock.free()
	
