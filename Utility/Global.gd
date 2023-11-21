extends Node

var GAME_WIDTH = 1000 * 12
var GAME_HEIGHT =  500 * 12 

enum DROP_TYPE{ 
	HEALTH
}
# world payload 
var player_name = "GUEST"
var mobs_count = 0
var cam: Camera2D = null

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
