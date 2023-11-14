extends CharacterBody2D

@export var item_type = "HEALTH"
func _ready():
	$PickupZone.body_entered.connect(_body_entered)
func _body_entered(body): 
	if body is Player:
		body.pick_up_item(self)
