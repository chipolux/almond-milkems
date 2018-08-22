extends Node

onready var delivery_area = get_node("milk_delivery")
onready var player = get_node("entities/player")

var milk_count = 7
var max_milk = 8

func _ready():
	player.connect("place_milk", self, "place_milk")

func _process(delta):
	for i in range(max_milk):
		i += 1
		if milk_count >= i:
			get_node("milks/milk%s" % i).show()
		else:
			get_node("milks/milk%s" % i).hide()

func player_in_delivery_area():
	for body in delivery_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false

func place_milk():
	if milk_count < max_milk and player_in_delivery_area():
		player.has_milk = false
		milk_count += 1