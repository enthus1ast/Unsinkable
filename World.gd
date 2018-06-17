extends Control

var schaufelIn = false
var power = 50
var deltasum = 0
onready var shipBody = $RigidBody2D
var currentTime = 0
var oldVelocity = Vector2(0,0)
onready var schaufel = $CanvasLayer/Control/ProgressBar/schaufel
onready var kohleAufSchaufel = $CanvasLayer/Control/ProgressBar/schaufel/kohleAufSchaufel
var keys = {}


func clearKeys():
	keys = {"steerLeft": false, "steerRight": false}

func chooseEisberg():
	var dice = randi() % 2
	if dice == 0: return load("res://eisberg.tscn").instance()
	elif dice == 1: return load("res://eisberg2.tscn").instance()
	elif dice == 2: return load("res://eisberg3.tscn").instance()

func spawnEisbergs():
	# 0 , (-8320)
	# 0, 1280
	for yidx in range(83):
		for xidx in range(randi() % 15 + 1):
			var eisberg = load("res://eisberg.tscn").instance()
			var rr = randi() % 2 + 1
			eisberg.scale = Vector2( rr, rr)
			add_child(eisberg)
			eisberg.position = Vector2( randi() % 1280, - (yidx * 100) ) #, randi() % 8320 ) 
			eisberg.rotation_degrees = randi() % 360
			print(eisberg.position)
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	clearKeys()
	spawnEisbergs()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
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
	
func _physics_process(delta):
	if $CanvasLayer/Lives.value <= 0:
		power = 0
	
	shipBody.apply_impulse(Vector2(0,0), Vector2(0, -(power / 3) * delta ).rotated(shipBody.rotation) )
	
	if keys.steerRight:
		var imp = Vector2(-(power / 1.5 ) * delta, 0  )
		shipBody.apply_impulse($RigidBody2D/PositionLeft.position,  imp )
	elif keys.steerLeft:
		var imp = Vector2((power / 1.5 ) * delta, 0)
		shipBody.apply_impulse($RigidBody2D/PositionRight.position, imp)
	oldVelocity = shipBody.linear_velocity

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
		elif abs(oldVelocity.x) > 10  or abs(oldVelocity.y) > 10:
			$CanvasLayer/Lives.value -= 1
		
		if $CanvasLayer/Lives.value <= 0:
			yield(get_tree().create_timer(3, true), "timeout")
			get_tree().change_scene("res://Winner.tscn")
	
	if body.is_in_group("winner"):
		$CanvasLayer/Control/time/Timer.stop()