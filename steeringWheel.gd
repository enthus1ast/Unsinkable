extends Sprite



func _ready():
	rotation = global_position.angle_to_point( get_global_mouse_position() )
	pass


func _process(delta):
	var startDir = rotation
	var dir = global_position.angle_to_point( get_global_mouse_position() )
	rotation = angleLerp(startDir,dir,delta*0.75)
	pass


func shortAngleDist(a0,a1):
	var maxVal = PI*2
	var da = fmod((a1 - a0), maxVal)
	return fmod(2*da , maxVal ) - da


func angleLerp(a0,a1,t):
	return a0 + shortAngleDist(a0,a1)*t