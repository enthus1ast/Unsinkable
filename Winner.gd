extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var labelRsi = find_node("LabelRsi")
onready var checkBoxRsi = find_node("CheckBoxRsi")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here.
	checkBoxRsi.pressed = config.rsi # todo is not found at runtime why?
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


#func _on_CheckBox_toggled(button_pressed):
#	pass # replace with function body

func _on_ButtonCheat_toggled(button_pressed):
	pass # replace with function body
	print("cheat:", button_pressed)
	config.cheat = button_pressed

func _on_CheckBoxRsi_toggled(button_pressed):
	pass # replace with function body
	config.rsi = button_pressed
	labelRsi.visible = button_pressed


func _on_CheckBoxDisableShader_toggled(button_pressed):
	pass # replace with function body
	config.lowQuality = button_pressed
