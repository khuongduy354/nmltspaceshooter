extends Node2D

func _ready():
	$Player.pname.text = "You here"
	$Player.pname.scale = Vector2(3,3)
	$Player.cam.enabled = false
	$Player.set_physics_process(false)
	$Player/CollisionPolygon2D.set_deferred("disabled",true)
