extends Node2D

var hexPosition: Vector2
var hexRef: Hex
var hexNeighbours: Array

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		pass
		
func changeColour():
	pass
