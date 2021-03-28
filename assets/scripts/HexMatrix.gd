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
var path = []

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
	
	setHexNeighbours()

	path = createPathToDestination()

	print ('valid path: ', isThereValidPath())

	print('-------------')
	for l in range(len(path) - 1):
		print (path[l].matrixPos)

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
			hex.hexRef = createdHex
	if (len(list_of_positions) == 0):
		createHex()
	

func isThereValidPath():
	if (path.empty()): 
		return false
	for i in len(path):
		if (path[i].matrixPos == targetHex.matrixPos):
			return true
	return false


func get_duplicates(a):
	if a.size() < 2:
		return []

	var seen = {}
	seen[a[0]] = true
	var duplicate_indexes = []

	for i in range(1, a.size()):
		var v = a[i]
		if seen.has(v):
			duplicate_indexes.append(i)
		else:
			seen[v] = true

	return duplicate_indexes

func setHexNeighbours():
	for	n in list_of_active_cells:
		n.hexNeighbours = getNeighbours(n)

func createPathToDestination () -> Array:
	var list_of_cells = []
	var visited = {}
	print ('the initial pos is ', activeHex.matrixPos, ' the destination is ', targetHex.matrixPos)
	pathNeighbours(list_of_cells, activeHex, targetHex, visited)

	return list_of_cells
	
func pathNeighbours(list, head, to, visited):
	if (head == null):
		print ('head is null')
		return 
	print ('head is ', head.matrixPos)
	if (list.empty()):
		var vec = head.matrixPos
		var key = '%s_%s' % [vec.x, vec.y]
		visited[key] = true
		list.append(head)
	if (head.matrixPos == to.matrixPos):
		print('heeere')
		list.append(head)
		return
	else:
		var nbrs:Array = head.hexNeighbours
		print ('size ' ,nbrs.size())
		var tempArray = nbrs
		var n = 0
		while n < len(nbrs):
			if (nbrs[n].hexRef.matrixPos == to.matrixPos):
				head = nbrs[n].hexRef
				print ('yo')

				list.append(head)
				return pathNeighbours(list, head, to, visited)
			var vec = nbrs[n].hexRef.matrixPos
			var key = '%s_%s' % [vec.x, vec.y]
			if (!visited.has(key)):
				visited[key] = false
			if (visited[key] == true):
				tempArray.remove(n)
			elif (visited[key] == false):
				visited[key] = true
			n+=1
		nbrs = tempArray
		print ('size a ' ,nbrs.size())
		
		if (nbrs.size() == 1):
			print ('hey')
			head = nbrs[0].hexRef
			list.append(head)
			return pathNeighbours(list, head, to, visited)
		elif (nbrs.size() > 1):
			head = getClosestNeighbourToPath(nbrs, targetHex.matrixPos)
			print ('theeeeere')
			list.append(head)
			return pathNeighbours(list, head, to, visited)

	return list

func getClosestNeighbourToPath(neighbours, targetPos):
	var closest = null
	var shortestDistance = INF
	var closestVector =  Vector2.ZERO

	for n in neighbours.size():
		var nb = neighbours[n].hexRef.matrixPos

		var dist = abs(targetPos.x - nb.x) + abs(targetPos.y - nb.y)
		print ('nb ', nb, ' has the distance of ', abs(dist), ' - SHORTEST IS : ', abs(shortestDistance))
		if (abs(dist) <= abs(shortestDistance)):
			shortestDistance = dist
			closestVector = nb

	print  ('shortest distance ', shortestDistance)
	for n in neighbours.size():
		var nb = neighbours[n].hexRef.matrixPos
		if (nb == closestVector):
			closest = neighbours[n]
			break

	if (closest == null):
		return null
	return closest.hexRef

func getHex(pos) -> Node2D:
	var hex = null 
	for l in list_of_positions:
		if (l.position == pos):
			hex = l.hex
	return hex

func getHexMatrix(pos) -> Hex:
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

		
	
		



