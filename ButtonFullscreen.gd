extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#func _on_ButtonFullscreen_pressed():
#	pass # Replace with function body.
#	print("foo")
#	OS.window_fullscreen = !OS.window_fullscreen

func _on_ButtonFullscreen_toggled(button_pressed):
	pass # replace with function body
	print("butto fullscreen")
	OS.window_fullscreen = !OS.window_fullscreen