extends Node

onready var delivery_area = get_node("milk_delivery")
onready var player = get_node("entities/player")
onready var animation_player = get_node("animation_player")

var elapsed_time = 0
var milk_count = 0
var strike_count = 0
var score = 0
var max_milks
var max_strikes


func _ready():
	max_milks = get_node("milks").get_child_count()
	max_strikes = get_node("strikes").get_child_count()
	player.connect("place_milk", self, "place_milk")
	get_node("timer").connect("timeout", self, "tick")
	for customer in get_node("customers").get_children():
		customer.connect("strike", self, "_strike")
		customer.connect("score", self, "_score")

func _process(delta):
	for i in range(max_milks):
		if milk_count > i:
			get_node("milks/milk%s" % i).show()
		else:
			get_node("milks/milk%s" % i).hide()
	for i in range(max_strikes):
		if strike_count > i:
			get_node("strikes/strike%s" % i).modulate = Color(1, 1, 1, 1)
		else:
			get_node("strikes/strike%s" % i).modulate = Color(1, 1, 1, 0.2)
	get_node("score").text = str(score)

func _strike():
	strike_count += 1

func _score():
	score += 1

func player_in_delivery_area():
	for body in delivery_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false

func place_milk():
	if milk_count < max_milks and player_in_delivery_area():
		player.has_milk = false
		milk_count += 1

func tick():
	elapsed_time += 1
	for customer in get_node("customers").get_children():
		if customer.can_accept_milk and milk_count > 0:
			milk_count -= 1
			customer.give_milk()
		customer.tick()