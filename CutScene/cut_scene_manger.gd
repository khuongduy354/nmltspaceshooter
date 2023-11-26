extends Node2D

@onready var EarthOnly = preload("res://CutScene/EarthOnly.tscn")
@onready var HumanWar = preload("res://CutScene/human_war.tscn")
@onready var KeplerAliensAttack = preload("res://CutScene/keplers_alien_attack.tscn")
@onready var KeplerMar = preload("res://CutScene/kepler_and_mars.tscn")
@onready var KeplerWithAlien = preload("res://CutScene/kepler_with_aliens.tscn")
@onready var KeplerRiftOpening = preload("res://CutScene/rift_opening.tscn")

@onready var world1rift = preload("res://CutScene/world_1_rift.tscn")
func pregame_flow(): 
	var curr_scene = EarthOnly.instantiate()
	add_child(curr_scene)
	await wait(5)
	curr_scene.queue_free()
	
	curr_scene  = KeplerMar.instantiate()	
	add_child(curr_scene)
	await wait(5)
	curr_scene.queue_free()
	
	curr_scene  = HumanWar.instantiate()	
	add_child(curr_scene)
	await wait(5)
	curr_scene.queue_free()

	curr_scene  = KeplerRiftOpening.instantiate()	
	add_child(curr_scene)
	await wait(10)
	curr_scene.queue_free()

	curr_scene  = KeplerAliensAttack.instantiate()	
	add_child(curr_scene)
	await wait(8)
	curr_scene.queue_free()

	curr_scene  = KeplerWithAlien.instantiate()	
	add_child(curr_scene)
	await wait(5)
	curr_scene.queue_free()
	
func wait(t): 
	await get_tree().create_timer(t).timeout
	
	
func _ready():
	pregame_flow()
