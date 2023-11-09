extends Node2D
@onready var boss = $Boss 
@onready var player = $Player
func _ready():
	boss._initialize_(player)
