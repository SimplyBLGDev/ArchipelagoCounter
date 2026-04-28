class_name LayoutTool_CompletionParticle
extends GPUParticles2D

func _ready():
	Counter.broadcast.connect(_on_broadcast)


func _on_broadcast(message: String, args: Dictionary):
	if message == "celebrate":
		emitting = not emitting
