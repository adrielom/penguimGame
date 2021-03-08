extends Node2D

export var side: = 10
export var xPosition: = 110
export var yPosition: = 100

export var xOffset: = 20
export var yOffset: = 20

var hexScene = preload("res://assets/Scenes/HexScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	createHex()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func createHex():
	for i in range(side):
		for j in range(side):
			var hex = hexScene.instance()
			if j % 2 != 0:
				hex.position = Vector2(i * xPosition + xOffset, j * yPosition + yOffset)
			else:
				hex.position = Vector2(i * xPosition + xPosition / 2 + xOffset  , j * yPosition + yOffset)
			$".".add_child(hex)
			
			
