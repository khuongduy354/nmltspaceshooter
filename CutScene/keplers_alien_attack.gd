extends Node2D
func _ready():
	Global.cam = $Marker2D/Camera2D
	$Boss/Hurtbox/CollisionShape2D2.set_deferred("disabled",true)
	$Boss._initialize_($KeplerSupporters/Player4)
	for enemy in $Enemies.get_children(): 
		enemy.set_physics_process(false)
		enemy.get_node("Hurtbox").get_node("CollisionPolygon2D2").set_deferred("disabled",true)
	for supporter in $MarsSupporters.get_children(): 
		supporter.set_physics_process(false)
		supporter.cam.enabled = false
		supporter.gun.BulletScene = preload("res://Utility/smaller_player_bullet.tscn")
		supporter.pname.text = "Mar"
		supporter.should_look=false
	for supporter in $KeplerSupporters.get_children(): 
		supporter.set_physics_process(false)
		supporter.cam.enabled = false
		supporter.gun.BulletScene  =  preload("res://Utility/smaller_red_bullet.tscn")
		supporter.pname.text = "Kepler"
		supporter.pname.rotation_degrees+=180
		
		
		supporter.sprite.texture = preload("res://assets/Objects/enemy-PhotoRoom.png-PhotoRoom (2).png")
		supporter.sprite.rotate(PI)
		supporter.sprite.scale=Vector2(2,2)
		
		supporter.should_look=false

func _physics_process(delta):
	var dir = Vector2.RIGHT
	for supporter in $MarsSupporters.get_children(): 
		supporter.gun.shoot()
		supporter.position += dir * 0.2
		supporter.animp.play("fly")
	for supporter in $KeplerSupporters.get_children(): 
		supporter.gun.shoot()
		supporter.position += dir * 0.2
	for enemy in $Enemies.get_children(): 
		enemy.gun.shoot()
		dir = dir.rotated(enemy.rotation)
		enemy.position += dir * 0.3
		
