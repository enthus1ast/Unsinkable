extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var labelRsi = find_node("LabelRsi")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here.
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_btnPlayAgain_pressed():
	pass # Replace with function body.
	get_tree().change_scene("res://World.tscn")


func _on_btnQuit_pressed():
	pass # Replace with function body.
	get_tree().quit()


func _on_CheckBox_toggled(button_pressed):
	pass # replace with function body
	config.rsi = button_pressed
	labelRsi.visible = button_pressed
	
	
