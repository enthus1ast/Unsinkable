extends Control

var schaufelIn = false
var power = 50
var deltasum = 0
var deltasumSchaufel = 0
onready var shipBody = $RigidBody2D
var currentTime = 0
var oldVelocity = Vector2(0,0)
onready var schaufel = $CanvasLayer/Control/ProgressBar/schaufel
onready var kohleAufSchaufel = $CanvasLayer/Control/ProgressBar/schaufel/kohleAufSchaufel
onready var foam = get_node("RigidBody2D/foam")
onready var eisberge = get_node("eisberge")
onready var clouds = get_node("clouds")
onready var animationPlayer = get_node("RigidBody2D/AnimationPlayer")

var keys = {}


func clearKeys():
	keys = {"steerLeft": false, "steerRight": false, "rsiPower": false}

func chooseEisberg():
	var dice = randi() % 2
	if dice == 0: return load("res://eisberg.tscn").instance()
#	elif dice == 1: return load("res://eisberg2.tscn").instance()
	elif dice == 2: return load("res://eisberg3.tscn").instance()
	else:return load("res://eisberg.tscn").instance()

func spawnEisbergs():
	# 0 , (-8320)
	# 0, 1280
	for yidx in range(83):
		for xidx in range(randi() % 12 + 1):
			var eisberg = chooseEisberg()  #load("res://eisberg.tscn").instance()
			var rr = randi() % 2 + 1
			eisberg.scale = Vector2( rr, rr)
			eisberge.add_child(eisberg)
			eisberg.position = Vector2( randi() % 1280, - (yidx * 100) ) #, randi() % 8320 ) 
			eisberg.rotation_degrees = randi() % 360
#			print(eisberg.position)

func chooseCloud():
#	var dice = randi() % 2
#	if dice == 0: return load("res://eisberg.tscn").instance()
#	elif dice == 1: return load("res://eisberg2.tscn").instance()
#	elif dice == 2: return load("res://eisberg3.tscn").instance()
	return load("res://Wolke.tscn").instance()
	
func spawnClouds():
	# 0 , (-8320)
	# 0, 1280
	for yidx in range(83):
		for xidx in range(randi() % 3 + 1):
			var cloud = chooseCloud()# load("res://eisberg.tscn").instance()
			var rr = randi() % 2 + 0
			cloud.scale = Vector2( rr, rr)
			clouds.add_child(cloud)
#			cloud.
			cloud.position = Vector2( randi() % 1280, - (yidx * 250) ) #, randi() % 8320 ) 
#			cloud.rotation_degrees = randi() % 360
#			print(cloud.position)


	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	clearKeys()
	spawnEisbergs()
	spawnClouds()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	deltasumSchaufel += delta
	if keys.rsiPower:
#		print("rsiPower")
		power += delta * 20
		if deltasumSchaufel > 0.20:
			schaufelIn = not schaufelIn
			deltasumSchaufel = 0
	
	$CanvasLayer/Control/ProgressBar.value = power
	deltasum += delta
	if deltasum > 0.2:
		power -= 1.5
		power = clamp(power, 0 , 100)
		deltasum = 0
	
	schaufel.flip_h = not schaufelIn
	kohleAufSchaufel.visible = not schaufelIn
#	kohleAufSchaufel
	$RigidBody2D/Particles2D.emitting = power / 4
	
	$CanvasLayer/ProcessSlider.value = int(clamp(abs(shipBody.position.y), 0, 8320))
	
func _physics_process(delta):
	if $CanvasLayer/Lives.value <= 0:
		power = 0
		clearKeys()
	
	shipBody.apply_impulse(Vector2(0,0), Vector2(0, -(power / 3) * delta ).rotated(shipBody.rotation) )
	
	if keys.steerRight:
		var imp = Vector2(-(power / 1.5 ) * delta, 0  )
		shipBody.apply_impulse($RigidBody2D/PositionLeft.position,  imp )
	elif keys.steerLeft:
		var imp = Vector2((power / 1.5 ) * delta, 0)
		shipBody.apply_impulse($RigidBody2D/PositionRight.position, imp)
	oldVelocity = shipBody.linear_velocity
	if shipBody.linear_velocity.length()>4:
		foam.emitting = true
	else:
		foam.emitting = false

func kohleRein():
	power += 5
	
func _input(event):
	if $CanvasLayer/Lives.value <= 0: return
	if event.is_action_pressed("ui_left"):
		if schaufelIn:
			schaufelIn = false
	if event.is_action_pressed("ui_right"):
		if not schaufelIn:
			schaufelIn = true
			kohleRein()
						
	if event.is_action_pressed("steerLeft"):
		keys.steerLeft = true
	if event.is_action_released("steerLeft"):
		keys.steerLeft = false
		
	if event.is_action_pressed("steerRight"):
		keys.steerRight = true
	if event.is_action_released("steerRight"):
		keys.steerRight = false
		
	if config.rsi:
		if event.is_action_pressed("ui_up"):
			keys.rsiPower = true
		if event.is_action_released("ui_up"):
			keys.rsiPower = false

func _on_Timer_timeout():
	pass # replace with function body
	currentTime += $CanvasLayer/Control/time/Timer.wait_time
	$CanvasLayer/Control/time.text = str(currentTime)


func _on_RigidBody2D_body_entered(body):
#	var motionTestResult =Physics2DTestMotionResult.new()
#	if shipBody.test_motion(shipBody.linear_velocity, 0.08, motionTestResult):
#		var k = motionTestResult.get_motion_remainder()
#		print("BÄÄÄM:" , k)
			
	if body.is_in_group("eisberg"):
		print("collided with eisberg: ", oldVelocity)
		if abs(oldVelocity.x) > 50  or abs(oldVelocity.y) > 50:
			$CanvasLayer/Lives.value = 0
			animationPlayer.play("kill")
		elif abs(oldVelocity.x) > 10  or abs(oldVelocity.y) > 10:
			$CanvasLayer/Lives.value -= 1
		
		if $CanvasLayer/Lives.value <= 0:
			animationPlayer.play("kill")
			yield(animationPlayer, "animation_finished")
#			yield(get_tree().create_timer(3, true), "timeout")
			get_tree().change_scene("res://Winner.tscn")
	
	if body.is_in_group("winner"):
		$CanvasLayer/Control/time/Timer.stop()

#func _on_ButtonFullscreen_pressed():
#	pass # Replace with function body.
#	OS.window_fullscreen = !OS.window_fullscreen



func _on_winner_body_entered(body):
	pass # Replace with function body.
	if body.is_in_group("ship"):
		$CanvasLayer/Control/time/Timer.stop()
		get_tree().change_scene("res://Winner.tscn")