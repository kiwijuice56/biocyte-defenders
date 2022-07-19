extends SubViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var screen_size: Vector2 = get_viewport().size
	$SubViewport.size = Vector2(screen_size.x, screen_size.x * (600.0/1124.0))
	print($SubViewport.size)
