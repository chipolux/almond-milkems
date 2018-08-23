extends Sprite

signal strike
signal score

export(Vector2) var in_position
export(Vector2) var out_position
export(int) var min_patience = 5
export(int) var max_patience = 15
export(int) var min_cooldown = 5
export(int) var max_cooldown = 15
onready var player = get_node("player")

var can_accept_milk = false
var waiting = false
var patience = rand_range(min_patience, max_patience)
var cooldown = rand_range(min_cooldown, max_cooldown)


func _ready():
	var walk_in = Animation.new()
	walk_in.set_length(1)
	walk_in.add_track(Animation.TYPE_VALUE)
	walk_in.track_set_path(0, ".:position")
	walk_in.track_insert_key(0, 0, out_position)
	walk_in.track_insert_key(0, 1, in_position)
	player.add_animation("walk_in", walk_in)
	var walk_out = Animation.new()
	walk_out.set_length(1)
	walk_out.add_track(Animation.TYPE_VALUE)
	walk_out.track_set_path(0, ".:position")
	walk_out.track_insert_key(0, 0, in_position)
	walk_out.track_insert_key(0, 1, out_position)
	player.add_animation("walk_out", walk_out)
	player.connect("animation_finished", self, "_anim_finished")
	player.connect("animation_started", self, "_anim_started")
	position = out_position

func _anim_started(name):
	can_accept_milk = false

func _anim_finished(name):
	if name == "walk_in":
		waiting = true
		patience = rand_range(min_patience, max_patience)
		can_accept_milk = true
	if name == "walk_out":
		waiting = false
		cooldown = rand_range(min_cooldown, max_cooldown)

func give_milk():
	if can_accept_milk:
		frame = 3
		player.queue("walk_out")

func tick():
	if player.is_playing():
		return
	if waiting:
		patience -= 1
		if patience > 2 and patience <= 4:
			frame = 1
		elif patience > 0 and patience <= 2:
			frame = 2
		elif patience <= 0:
			frame = 2
			emit_signal("strike")
			player.queue("walk_out")
	else:
		cooldown -= 1
		if cooldown <= 0:
			frame = 0
			emit_signal("score")
			player.queue("walk_in")