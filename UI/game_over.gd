extends CanvasLayer

@onready var boss_kills = $GameOverPack/VBoxContainer2/VBoxContainer/HBoxContainer/BossKills
@onready var mobs_kills = $GameOverPack/VBoxContainer2/VBoxContainer/HBoxContainer2/MobsKills
@onready var survival_time = $GameOverPack/VBoxContainer2/VBoxContainer/HBoxContainer3/SurvivalTime

func _ready():
	set_boss_kills(Global.destroyed_bosses)
	set_mos_kills(Global.destroyed_mobs)
	set_survival_time(Global.survival_time)
	
func set_boss_kills(val): 
	boss_kills.text = str(val)

func set_mos_kills(val): 
	mobs_kills.text = str(val)

func set_survival_time(val): 
	survival_time.text = str(val) + " secs"


func _on_exit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
