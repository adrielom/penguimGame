extends Node2D


export var side: = 10
export var xPosition: = 110
export var yPosition: = 100

export var xOffset: = 20
export var yOffset: = 20
export var penguimOffset: = Vector2(-21, -38)

var list_of_positions: = []
var list_of_active_cells: = []
var circleCells = []
var activeHex: Hex
var targetHex: Hex
export var noiseThreshold: = 1.0


var hasFinishedLoading: = false

const hexScene = preload("res://assets/Scenes/HexScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	createHex()
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()

	
	for i in list_of_positions:
		if (i.active == true):
			list_of_active_cells.append(i)
	
	var ind = rand.randi() % len(list_of_active_cells)
	var ind2 = rand.randi() % len(list_of_active_cells)
	activeHex = list_of_active_cells[ind]
	$Player.position = activeHex.worldPosition - penguimOffset
		
	targetHex = list_of_active_cells[ind2]

	activeHex.hex.modulate = Color.pink

	targetHex.hex.modulate = Color.green

	hasFinishedLoading = true


# olhar a criação da matrix
func createHex():
	randomize()
	var createdHex = null
	var noiser = Noiser.new()
	
	for i in range(side):
		for j in range(side):
			var noiseValue = noiser.getNoise(i * noiser.getArraySide() / side, j * noiser.getArraySide() / side)

			var matrixPos = Vector2(i, j)

			var hex = hexScene.instance()
			
			if j % 2 != 0:
				hex.position = Vector2(i * xPosition + xOffset, j * yPosition + yOffset) - penguimOffset
			else:
				hex.position = Vector2(i * xPosition + xPosition / 2 + xOffset  , j * yPosition + yOffset) - penguimOffset

			if (noiseValue >= noiseThreshold):	
				createdHex = Hex.new(hex, Vector2(i,j), matrixPos, hex.position, true)
				hex.visible = true
			else:
				createdHex = Hex.new(hex, Vector2(i,j), matrixPos, hex.position, false)
				hex.visible = false
			list_of_positions.append(createdHex)
			$".".add_child(hex)
			hex.get_node("Label").text = '{i} {j}'.format({'i': createdHex.matrixPos.x, 'j': createdHex.matrixPos.y})
			hex.hexPosition = createdHex.matrixPos
	if (len(list_of_positions) == 0):
		createHex()

	
func getHex(pos) -> Node2D:
	var hex = null 
	for l in list_of_positions:
		if (l.position == pos):
			hex = l.hex
	return hex

func getHexMatrix(pos) -> Node2D:
	var hex = null 
	for l in list_of_active_cells:
		if (l.matrixPos == pos):
			hex = l.hex
	return hex
	
	
func getNeighbours (hex: Hex):
	var list_of_neighbours = []
	
	var neighboursPositions 
	
	if int(hex.matrixPos.y) % 2 == 0:
		neighboursPositions = [
			Vector2(hex.matrixPos.x - 1, hex.matrixPos.y),
			Vector2(hex.matrixPos.x + 1, hex.matrixPos.y),
			Vector2(hex.matrixPos.x, hex.matrixPos.y + 1),
			Vector2(hex.matrixPos.x + 1, hex.matrixPos.y + 1),
			Vector2(hex.matrixPos.x, hex.matrixPos.y - 1),
			Vector2(hex.matrixPos.x + 1, hex.matrixPos.y - 1)
		] 
	else:
		neighboursPositions = [
			Vector2(hex.matrixPos.x - 1, hex.matrixPos.y),
			Vector2(hex.matrixPos.x + 1, hex.matrixPos.y),
			Vector2(hex.matrixPos.x - 1, hex.matrixPos.y + 1),
			Vector2(hex.matrixPos.x, hex.matrixPos.y + 1),
			Vector2(hex.matrixPos.x - 1, hex.matrixPos.y - 1),
			Vector2(hex.matrixPos.x, hex.matrixPos.y - 1)
		]
	
	for n in neighboursPositions:
		var h = getHexMatrix(n)
		if n != null and h != null:
			list_of_neighbours.append(h)		
	
	return list_of_neighbours

class Noiser: 
	
	var imageSide
	var noise

	
	func _init():
		imageSide = 512
		noise = OpenSimplexNoise.new()
		noise.seed = randi()
		noise.octaves = 5
		noise.period = 10
			
	func getArraySide():
		return imageSide
	
	func getNoise(i, j):
		return noise.get_noise_2d(i, j)

		
	
		



