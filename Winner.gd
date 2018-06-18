extends Control

onready var labelRsi = find_node("LabelRsi")
onready var checkBoxRsi = find_node("CheckBoxRsi")
onready var viewportRect = get_viewport_rect()

func _ready():
	checkBoxRsi.pressed = config.rsi # todo is not found at runtime why?
	pass


func _on_btnPlayAgain_pressed():
	pass # Replace with function body.
	get_tree().change_scene("res://World.tscn")


func _on_btnQuit_pressed():
	pass # Replace with function body.
	get_tree().quit()


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
