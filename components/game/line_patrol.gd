extends Path2D

@export var speed:int = 200

@onready var follow:PathFollow2D = $PathFollow2D
@onready var line_node: LineNode = $PathFollow2D/LineNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	follow.set_progress(follow.progress + speed * delta)
	line_node.node_moved.emit(line_node, follow.position)
