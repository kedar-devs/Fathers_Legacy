extends KinematicBody2D
enum{
	MOVE,
	ROLL,
	ATTACK
}
var state=MOVE
var velocity=Vector2.ZERO
export var friction=400
export var Acceleration=250
export var MAX_SPEED=80
var roll_vector=Vector2.UP
onready var animationPlayer=$AnimationPlayer
onready var animationTree=$AnimationTree
onready var animationState=animationTree.get("parameters/playback")
onready var SwordHitbox=$Swordhitbox/HitBox
func _ready():
	animationTree.active=true
	SwordHitbox.knockback_vector=roll_vector

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			RollState(delta)
	
	
func move_state(delta):
	var input_vector=Vector2.ZERO
	input_vector.x=Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y=Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector=input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector=input_vector
		SwordHitbox.knockback_vector=input_vector
		animationTree.set("parameters/idle/blend_position",input_vector)
		animationTree.set("parameters/run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		
		animationState.travel("run")
		
		velocity=velocity.move_toward(input_vector*MAX_SPEED,Acceleration*delta)
		
		
	else:
		animationState.travel("idle")
		velocity=velocity.move_toward(Vector2.ZERO,friction*delta)
		
	
	velocity=move_and_slide(velocity)
	if Input.is_action_just_pressed("roll"):
		state=ROLL
	if Input.is_action_just_pressed("attack"):
		state=ATTACK
func move():
	velocity=move_and_slide(velocity)
func RollState(delta):
	velocity=roll_vector*MAX_SPEED*1.5
	animationState.travel("Roll")
	move()
func attack_state(delta):
	velocity=Vector2.ZERO
	animationState.travel("Attack")
func RollAnimationFinish():
	velocity=Vector2.ZERO
	state=MOVE
func attack_animation_finished():
	state=MOVE
	
	
