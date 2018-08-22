extends KinematicBody2D

const SPEED = 125
var velocity = Vector2()
onready var udder_detector = get_node("udder_detector")
var has_milk = false
var udder_in_reach = false

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
	udder_in_reach = _udder_check()
	
func _process(delta):
	if velocity.x < 0:
		get_node("sprite").scale = Vector2(-1, 1)
	elif velocity.x > 0:
		get_node("sprite").scale = Vector2(1, 1)
	if udder_in_reach and not has_milk:
		get_node("sprite").frame = 1
	elif has_milk:
		get_node("sprite").frame = 2
	else:
		get_node("sprite").frame = 0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_milk()
		
func _in_personal_space(body):
	if body.is_in_group("cow"):
		body.scare(global_position)

func _udder_check():
	for area in udder_detector.get_overlapping_areas():
		if area.is_in_group("udder"):
			return true
	return false
	
func get_milk():
	if udder_in_reach and not has_milk:
		has_milk = true
		for body in udder_detector.get_overlapping_bodies():
			if body.is_in_group("cow"):
				body.scare(global_position)