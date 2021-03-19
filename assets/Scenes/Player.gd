extends Node2D


var HexMatrix 
var activeHex
var targetHex
var memoizedActiveHex
var neighbours 
var playerSelected: = false

func _ready():
	HexMatrix = get_tree().get_root().get_child(0)
	
	
func _process(delta):
	if HexMatrix.hasFinishedLoading:
		targetHex = HexMatrix.targetHex
		activeHex = HexMatrix.activeHex
		if (activeHex != memoizedActiveHex or memoizedActiveHex == null):
			neighbours = getNeighbours()
			memoizedActiveHex = activeHex
	
func getNeighbours ():
	return HexMatrix.getNeighbours(activeHex)

func changeNeighboursColour():
	print(len(neighbours))
	if (len(neighbours) > 0):
		for n in neighbours:
			n.get_node('hex').modulate = Color.white
		neighbours.resize(0)
		return
	neighbours = getNeighbours()
	for n in neighbours:
		n.get_node('hex').modulate = Color.orange


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		changeNeighboursColour()
