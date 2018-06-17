extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var schaufelIn = false
var power = 50
var deltasum = 0
onready var shipBody = $RigidBody2D
var currentTime = 0
var oldVelocity = Vector2(0,0)

var keys = {}

func clearKeys():
	keys = {"steerLeft": false, "steerRight": false}

func spawnEisbergs():
#	0 , (-8320)
# 0, 1280
#	for idx in range(100):
	for yidx in range(83):
		
		for xidx in range(randi() % 3 + 1):
			var eisberg = load("res://eisberg.tscn").instance()
			var rr = randi() % 2 + 1
			eisberg.scale = Vector2( rr, rr)
			add_child(eisberg)
			eisberg.position = Vector2( randi() % 1280, - (yidx * 100) ) #, randi() % 8320 ) 
			print(eisberg.position)

	

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
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
	
	$RigidBody2D/Particles2D.emitting = power / 4
	

func _physics_process(delta):
#	print(delta)

	#bool test_motion( Vector2 motion, float margin=0.08, Physics2DTestMotionResult result=null )
#	var motion
#	print(shipBody.linear_velocity)
	
	shipBody.apply_impulse(Vector2(0,0), Vector2(0, -(power / 3) * delta ).rotated(shipBody.rotation) )
	
	print(shipBody.applied_torque)
	
	if keys.steerRight:
#		shipBody.apply_impulse(Vector2(0,+90), Vector2(-(power / 10) * delta, 0  ))
		var imp = Vector2(-(power / 1.5 ) * delta, 0  )
		shipBody.apply_impulse($RigidBody2D/PositionLeft.position,  imp )
#		shipBody.applied_torque -=  clamp(100 *delta, 0 , 20)
#		shipBody.applied_torque =  clamp( shipBody.applied_torque + 500 *delta, -500 , 500)
	elif keys.steerLeft:
		var imp = Vector2((power / 1.5 ) * delta, 0)
		shipBody.apply_impulse($RigidBody2D/PositionRight.position, imp)
#		shipBody.applied_torque += 100 *delta
#		shipBody.applied_torque =  clamp( shipBody.applied_torque  *delta, -500 , 500)
	oldVelocity = shipBody.linear_velocity

func kohleRein():
	power += 5
	
	
func _input(event):
	if $CanvasLayer/Lives.value <= 0: return
	if event.is_action_pressed("ui_left"):
		if schaufelIn:
			schaufelIn = false
			print("raus")
	if event.is_action_pressed("ui_right"):
		if not schaufelIn:
			schaufelIn = true
			print("rein")
			kohleRein()
			
	if event.is_action_pressed("steerLeft"):
		keys.steerLeft = true
	if event.is_action_released("steerLeft"):
		keys.steerLeft = false
		
	if event.is_action_pressed("steerRight"):
		keys.steerRight = true
	if event.is_action_released("steerRight"):
		keys.steerRight = false

#		body.apply_impulse(Vector2(0,20), Vector2(0, -(power / 10))) #* delta ))
		
			
			

func _on_Timer_timeout():
	pass # replace with function body
	currentTime += $CanvasLayer/Control/time/Timer.wait_time
	$CanvasLayer/Control/time.text = str(currentTime)


func _on_RigidBody2D_body_entered(body):
#	var motionTestResult =Physics2DTestMotionResult.new()
#	if shipBody.test_motion(shipBody.linear_velocity, 0.08, motionTestResult):
#		var k = motionTestResult.get_motion_remainder()
#		print("BÄÄÄM:" , k)
			
	pass # replace with function body
	if body.is_in_group("eisberg"):
		print("collided with eisberg: ", oldVelocity)
#		print(shipBody.linear_velocity)
#		$RigidBody2D

		if abs(oldVelocity.x) > 50  or abs(oldVelocity.y) > 50:
			$CanvasLayer/Lives.value = 0
		elif abs(oldVelocity.x) > 10  or abs(oldVelocity.y) > 10:
			$CanvasLayer/Lives.value -= 1
			
#			if $CanvasLayer/Lives.value == 0:
				
	
	if body.is_in_group("winner"):
		$CanvasLayer/Control/time/Timer.stop()
