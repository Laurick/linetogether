extends Node2D

@onready var nodes: Node2D = $Nodes

var node_start:LineNode
var node_end:LineNode

var segments:Array[LineConnection] = []
var segment

func _ready() -> void:
	load_riddle()


func get_all_line_nodes(in_node, array := []):
	if in_node is LineNode: 
		array.push_back(in_node)
	else:
		for child in in_node.get_children():
			array = get_all_line_nodes(child, array)
	return array

func load_riddle():
	var scene = load("res://line_seeker/riddles/line_seeker%d.tscn" % Constants.index).instantiate()
	for c in nodes.get_children():
		nodes.remove_child(c)
		
	for c in scene.get_children():
		c.reparent(nodes)
		
	for c in get_all_line_nodes(nodes):
		if c is LineNode:
			c.node_clicked.connect(on_node_clicked)
			c.node_released.connect(on_node_released)


func on_node_clicked(line_node):
	node_start = line_node
	segment = load("res://line_seeker/line_connection.tscn").instantiate()
	segment.setup(node_start.position, node_start.position)
	nodes.add_child(segment)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and segment:
		segment.update_end_point(event.position)
	elif event is InputEventMouseButton and !event.is_pressed():
		clear_segment()
	if event is InputEventKey and event.is_pressed():
		match (event.key_label):
			KEY_ESCAPE:
				go_to_main()
			KEY_R:
				load_riddle()
			KEY_D:
				if !segments.is_empty():
					var s = segments.pop_back()
					s.disconnect_line_connections()
					nodes.remove_child(s)

func on_node_released(line_node):
	node_end = line_node
	if node_start.try_to_connect_line_node(node_end):
		if !segment.is_colliding:
			node_start.connect_line_node(node_end)
			segment.update_end_point(node_end.position)
			segments.append(segment)
			segment.place(node_start, node_end)
			segment = null
			check_resolved()
		else:
			clear_segment()
	else:
		clear_segment()

func clear_segment():
	if segment:
		nodes.remove_child(segment)
		segment.queue_free()
		segment = null

func check_resolved():
	var resolved:bool = true
	for c in nodes.get_children():
		if c is LineNode:
			resolved = resolved && c.is_resolved()
	if resolved: 
		Constants.index += 1
		if Constants.index <= Constants.max_riddles:
			load_riddle()
		else:
			go_to_main()

func go_to_main():
	get_tree().change_scene_to_file("res://main.tscn")
