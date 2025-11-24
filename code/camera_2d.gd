extends Camera2D

# Fattore velocità trascinamento
@export var drag_speed: float = 1.0

# Fattore velocità zoom
@export var zoom_speed: float = 0.1

# Limiti zoom
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0

var dragging := false
var last_mouse_pos := Vector2.ZERO

func _input(event):
	# Inizio trascinamento con tasto destro
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_pos = event.position
			else:
				dragging = false

		# Zoom con rotellina
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)

	# Se trascina, muovi la camera
	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position -= delta * drag_speed
		last_mouse_pos = event.position


func zoom_camera(amount: float):
	var new_zoom = zoom + Vector2(amount, amount)
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom
