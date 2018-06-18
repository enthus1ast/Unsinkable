extends Control

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

func _on_ButtonVisitChromeTrip_pressed():
	pass # replace with function body
	OS.shell_open("https://code0.itch.io/chrome-trip")


func _on_ButtonMainMenu_pressed():
	pass # replace with function body
	get_tree().change_scene("res://MainMenu.tscn")
