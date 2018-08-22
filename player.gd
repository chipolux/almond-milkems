extends KinematicBody2D

const SPEED = 125
var velocity = Vector2()
onready var udder_detector = get_node("udder_detector")

func _ready():
	get_node("personal_space").connect("body_entered", self, "_in_personal_space")

func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	move_and_slide(velocity * SPEED)
	for area in udder_detector.get_overlapping_areas():
		if area.is_in_group("udder"):
			print("udder in reach!")
	
func _process(delta):
	if velocity.x < 0:
		get_node("sprite").scale = Vector2(-1, 1)
	elif velocity.x > 0:
		get_node("sprite").scale = Vector2(1, 1)
		
func _in_personal_space(body):
	if body.is_in_group("cow"):
		body.scare(global_position)