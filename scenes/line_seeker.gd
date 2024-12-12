extends Node2D

@onready var nodes: Node2D = $Nodes
@onready var lines_container: HBoxContainer = $CanvasLayer/HBoxContainer
@onready var options: Control = $CanvasLayer/Control2/PanelContainer/Options

var node_start:LineNode
var node_end:LineNode

var segments:Array[LineConnection] = []
var segment

var data:RiddleData
var line_selected = 0

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
	var scene = load("res://riddles/line_seeker%s.tscn" % GameData.level_index).instantiate()
	data = load("res://riddles/line_seeker%s.tres" % GameData.level_index)
	
	segments.clear()
	
	for c in nodes.get_children():
		nodes.remove_child(c)
		if c is LineNode:
			options.show_connections_changes.disconnect(c.set_show_connections)
		c.queue_free()
		
	for c in lines_container.get_children():
		lines_container.remove_child(c)
	
	for c in scene.get_children():
		c.reparent(nodes)
		options.show_connections_changes.connect(c.set_show_connections)
		
	for c in get_all_line_nodes(nodes):
		if c is LineNode:
			c.node_clicked.connect(on_node_clicked)
			c.node_released.connect(on_node_released)

	var index = 1
	var group = ButtonGroup.new()
	for line_riddle in data.lines:
		var b = load("res://components/game/line_button.tscn").instantiate()
		b.texture_normal = load("res://images/UI/%d_line.png" % index)
		b.texture_pressed = load("res://images/UI/%d_line_selected.png" % index)
		b.set_meta("segments", data.lines[index-1])
		b.toggle_mode = true
		b.button_group = group
		b.line_selected.connect(_on_line_changed)
		lines_container.add_child(b)
		index += 1

	await get_tree().process_frame
	var a = lines_container.get_child(0)
	a.button_pressed = true
	line_selected = 0


func _on_line_changed(selected):
	line_selected = selected


func on_node_clicked(line_node, event):
	if lines_container.get_child(line_selected).get_meta(LineButton.SEGMENTS_META_KET, 0) == 0: return
	node_start = line_node
	segment = load("res://components/game/line_connection.tscn").instantiate()
	segment.setup(node_start.position, event.position, line_selected+1)
	nodes.add_child(segment)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and segment:
		segment.update_end_point(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if segment and segment.can_make_a_joint():
			segment.make_a_joint(event.position) # TODO: revisar
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
					var button_index:int = s.get_segments()-1
					lines_container.get_child(button_index).update_number_of_lines_by(1)
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
			lines_container.get_child(line_selected).update_number_of_lines_by(-1)
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
		GameData.level_index += 1
		GameData.unlocked_level_index = max(GameData.unlocked_level_index, GameData.level_index)
		FileUtils.new().save_data_into_filegame(GameData.get_player_data())
		if GameData.level_index <= GameData.max_riddles:
			load_riddle()
		else:
			go_to_main()


func go_to_main():
	get_tree().change_scene_to_file("res://scenes/level_selector.tscn")
