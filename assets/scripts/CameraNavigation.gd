extends Camera2D

export var speed = 20

export var movementState: = true

func _ready():
	print (self.zoom)

func _physics_process(delta):
	if movementState:
		movement()
	
func movement():
	if(Input.is_action_pressed("ui_left")):
		self.position.x -= speed
	if(Input.is_action_pressed("ui_right")):
		self.position.x += speed
	if(Input.is_action_pressed("ui_up")):
		self.position.y -= speed
		if (Input.is_key_pressed(KEY_ALT)):
			if (self.zoom.x > 0.9):
				self.zoom.y -= speed * .005
				self.zoom.x -= speed * .005
			else:
				self.zoom.x = 0.8
				self.zoom.y = 0.8

			
	if(Input.is_action_pressed("ui_down")):
		self.position.y += speed
		if (Input.is_key_pressed(KEY_ALT)):
			if (self.zoom.x > 1.5):
				self.zoom.y += speed * .005
				self.zoom.x += speed * .005
			else:
				self.zoom.x = 1.5
				self.zoom.y = 1.5
