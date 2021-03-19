class_name Hex

var hex: Node2D
var position: Vector2
var matrixPos: Vector2
var worldPosition: Vector2
var active: bool

func _init(hex, position, matrixPos, worldPosition, active):
	self.hex = hex
	self.position = position
	self.matrixPos = matrixPos
	self.worldPosition = worldPosition
	self.active = active
