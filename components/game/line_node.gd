class_name LineNode extends Area2D

enum LineNodeGroup {ALL, ONE, TWO, THREE}
enum LineNodeType {A, B, C, D}

signal node_clicked(line_node, event)
signal node_released(line_node)
signal node_moved(node, new_position)

@onready var label: Label = $Sprite2D/Label
@onready var shadow: Sprite2D = $Shadow
@onready var sprite_2d: Sprite2D = $Sprite2D

var type:LineNodeType = LineNodeType.B
@export var group:LineNodeGroup = LineNodeGroup.ALL
@export var max_connections:int = 0
var connections_left:int = 0
var mouse_in:bool = false
var connectioned_to = []
var show_connections:bool = GameData.show_connections

func _ready() -> void:
	connections_left = max_connections
	update_form()
	update_label()
	update_color()

func update_color():
	match(group):
		LineNodeGroup.ALL:
			sprite_2d.modulate = Color.WHITE
		LineNodeGroup.ONE:
			sprite_2d.modulate = Color.GREEN
		LineNodeGroup.TWO:
			sprite_2d.modulate = Color.BLUE
		LineNodeGroup.THREE:
			sprite_2d.modulate = Color.RED
		_:
			sprite_2d.modulate = Color.WHITE
	
func update_form():
	var image = load("res://images/tile%s.png" % [str(LineNodeType.find_key(type))])
	shadow.texture = image
	sprite_2d.texture = image

func setup(_max_connections:int):
	max_connections = _max_connections
	connections_left = _max_connections


func is_resolved() -> bool:
	return connections_left == 0


func disconnect_line_node(node:LineNode):
	connections_left += 1
	connectioned_to.erase(node)
	update_label()


func try_to_connect_line_node(node:LineNode) -> bool:
	if connections_left == 0 or node.connections_left == 0: return false
	if node == self: return false
	if node.type != self.type: return false
	return true


func connect_line_node(node:LineNode) -> void:
	if connections_left == 0 or node.connections_left == 0: return
	connections_left -= 1
	node.connections_left -= 1
	
	update_label()
	node.update_label()
	
	connectioned_to.append(node)
	node.connectioned_to.append(self)


func update_label():
	label.text = str(connections_left) if show_connections else ""


func _input(event: InputEvent) -> void:
	if mouse_in:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				node_clicked.emit(self, event)
			else:
				node_released.emit(self)


func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false


func set_show_connections(new_value:bool):
	show_connections = new_value
	update_label()
