extends Node

var GAME_WIDTH = 1000 * 12
var GAME_HEIGHT =  500 * 12 

enum DROP_TYPE{ 
	HEALTH
}

# world payload 
signal spawner_destroyed
signal swarm_player

var player_name = "GUEST"
var player: Player = null 
var mobs_count = 0
var cam: ShakeCamera = null
var destroyed_mobs = 0
var destroyed_bosses = 0
var survival_time = 0

func frame_freeze(time_scale, duration): 
	Engine.time_scale = time_scale 
	await get_tree().create_timer(time_scale * duration).timeout 
	Engine.time_scale = 1.0

func check_out_screen(gpos:Vector2): 
	var out_width = gpos.x > GAME_WIDTH * 1.25 or gpos.x < -1000
	var out_height = gpos.y > GAME_HEIGHT * 1.25 or gpos.y < -1000
	if out_width or out_height: 
		return true 
	return false
func percent_pick(val): 
	if randi()%100+1 <=  val: 
		return true 
	return false

func fade_left_trans_to(path: String,speed = 1.0): 
	var fade_trans = preload("res://vfx/swipe_transistion.tscn").instantiate()
	get_tree().root.add_child(fade_trans)
	fade_trans.animp.playback_speed = speed
	fade_trans.transition_to(path)
