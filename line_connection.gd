class_name LineConnection extends Area2D

@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var segment_shape:SegmentShape2D

@export var start:Vector2
@export var end:Vector2
var is_colliding: bool
var node_start:LineNode
var node_end:LineNode

func _ready() -> void:
	update_color(Color.CHARTREUSE)
	is_colliding = false
	line_2d.add_point(start,0)
	line_2d.add_point(end,1)
	segment_shape = collision_shape_2d.shape as SegmentShape2D
	segment_shape.a = start
	segment_shape.b = end


func setup(_start:Vector2, _end:Vector2):
	start = _start
	end = _end


func update_color(new_color:Color):
	line_2d.default_color = new_color


func update_end_point(new_end:Vector2):
	end = new_end
	line_2d.points[1] = new_end
	segment_shape.b = new_end


func place(_node_start:LineNode, _node_end:LineNode):
	node_start = _node_start
	node_end = _node_end
	start = node_start.position
	end = node_end.position
	update_line_position()
	node_end.node_moved.connect(update_node_position)
	node_start.node_moved.connect(update_node_position)



func update_node_position(node:LineNode, new_position):
	if node_end == node:
		end = new_position
	elif node_start == node:
		start = new_position
	update_line_position()


func update_line_position():
	var diff_a = start-end
	diff_a *= 0.05
	var new_start = start-diff_a
	line_2d.points[0] = new_start
	segment_shape.a = new_start
	var diff_b = end-start
	diff_b *= 0.05
	var new_end = end-diff_b
	line_2d.points[1] = new_end
	segment_shape.b = new_end


func disconnect_line_connections():
	node_end.node_moved.disconnect(update_line_position)
	node_start.node_moved.disconnect(update_line_position)
	node_start.disconnect_line_node(node_end)
	node_end.disconnect_line_node(node_start)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if (self.segment_shape.get_rect() == area.segment_shape.get_rect()): return
	update_color(Color.RED)
	is_colliding = true


func _on_area_exited(area: Area2D) -> void:
	update_color(Color.CHARTREUSE)
	is_colliding = false
