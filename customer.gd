extends Sprite

export(Vector2) var in_position
export(Vector2) var out_position
onready var player = get_node("player")


func _ready():
	var anim = player.get_animation("walk_in")
	anim.track_set_key_value(0, 0, out_position)
	anim.track_set_key_value(0, 1, in_position)
	position = out_position
	
	
func walk_in():
	player.play("walk_in")
	
func walk_out():
	player.play_backwards("walk_in")