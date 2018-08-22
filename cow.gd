extends KinematicBody2D


const WANDER_DISTANCE = 150
const CLOSE_ENOUGH = 20

onready var interest_timer = get_node("interest_timer")

var velocity = Vector2()
var interest_point
var interest_speed


func _ready():
	interest_timer.connect("timeout", self, "update_interest_point")
	update_interest_point()

func _physics_process(delta):
	velocity = Vector2()
	var distance = global_position.distance_to(interest_point)
	var direction = (global_position - interest_point).normalized()
	if distance <= CLOSE_ENOUGH and interest_timer.is_stopped():
		# we've just arrived at the interest point
		interest_timer.set_wait_time(rand_range(1.5, 4.5))
		interest_timer.start()
	elif distance >= CLOSE_ENOUGH:
		# not to the interest point yet, keep going
		velocity -= (direction * min(distance, interest_speed))
	var collision = move_and_collide(velocity * delta)
	if collision:
		move_and_slide(velocity)
		if not collision.collider.is_in_group("cow") and interest_timer.is_stopped():
			interest_timer.set_wait_time(rand_range(1.5, 4.5))
			interest_timer.start()
		
func _process(delta):
	if velocity.x < 0:
		get_node("sprite").scale = Vector2(-0.9, 0.9)
	elif velocity.x > 0:
		get_node("sprite").scale = Vector2(0.9, 0.9)
	
func update_interest_point():
	var x = rand_range(position.x - WANDER_DISTANCE, position.x + WANDER_DISTANCE)
	var y = rand_range(position.y - WANDER_DISTANCE, position.y + WANDER_DISTANCE)
	interest_point = Vector2(x, y)
	interest_speed = rand_range(10, 70)
	print("updated interest point")
	
func scare(source_position):
	interest_timer.stop()
	var direction = (global_position - source_position).normalized()
	interest_point = position + (direction * 400)
	interest_speed = 250
	print("scared to %s" % interest_point)