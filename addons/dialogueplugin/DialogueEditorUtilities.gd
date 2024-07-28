extends Control

var singNode = preload("res://addons/dialogueplugin/SingleNode.tscn")
@export var my_button_path: NodePath
# Called when the node enters the scene tree for the first time.
func _ready():
	var button = $Panel/SingleNode
	button.connect("pressed",Callable(self, "_on_single_node_pressed"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_single_node_pressed():
	print("Button pressed in DialogueEditor!")
	var node = singNode.instantiate()
	$GraphEdit.add_child(node)
	pass # Replace with function body.
