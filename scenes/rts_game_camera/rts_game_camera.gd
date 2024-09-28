extends Node3D
class_name RTSGameCamera

@onready var camera_socket: Node3D = $CameraSocket
@onready var camera: Camera3D = $CameraSocket/Camera3D

# Camera movement parameters
var camera_base_move_speed: float = 20.0
var camera_drag_move_speed: float = 60.0
var camera_mouse_movement_direction: Vector3 = Vector3.ZERO

# Rotation parameters
var camera_base_rotation_speed: float = 2.0
var camera_socket_rotation_minimum:float = -1.5
var camera_socket_rotation_maximum:float = 0.0
var camera_rotation_direction: int = 0

# Zoom parameters
var camera_zoom_speed: float = 40.0
var camera_zoom_dampening: float = 0.9
var camera_zoom_minimum: float = 10.0
var camera_zoom_maximum: float = 25.0
var camera_zoom_direction: float = 0

# Edge pan parameters
var edge_pan_margin: int = 16
var edge_pan_speed: float = 12

var last_mouse_position: Vector2 = Vector2.ZERO

var camera_base_can_move: bool = true
var camera_can_drag_move: bool = true
var camera_base_can_rotate: bool = true
var camera_socket_can_rotate: bool = true
var camera_can_zoom: bool = true
var camera_can_edge_pan: bool = false
var camera_can_mouse_rotate: bool = true

var camera_can_process: bool = true
var is_rotating: bool = false
var is_mouse_rotating: bool = false
var is_mouse_moving: bool = false


func _process(delta: float) -> void:
	if !camera_can_process:
		return
	camera_move(delta)
	camera_drag_move(delta)
	camera_zoom(delta)
	camera_edge_pan(delta)
	camera_rotation(delta)
	rotate_to_mouse_offset(delta)


func _unhandled_input(event: InputEvent) -> void:
	# Zoom
	if event.is_action("camera_zoom_in"):
		camera_zoom_direction = -1
	elif event.is_action("camera_zoom_out"):
		camera_zoom_direction = 1
	
	# Rotation
	if event.is_action_pressed("camera_rotate_right"):
		is_rotating = true
		camera_rotation_direction = -1
	elif event.is_action_pressed("camera_rotate_left"):
		is_rotating = true
		camera_rotation_direction = 1
	elif event.is_action_released("camera_rotate_right") or event.is_action_released("camera_rotate_left"):
		is_rotating = false
	if event.is_action_pressed("camera_mouse_rotate"):
		is_mouse_rotating = true
		last_mouse_position = get_viewport().get_mouse_position()
	elif event.is_action_released("camera_mouse_rotate"):
		is_mouse_rotating = false
	
	# Drag move
	if event.is_action_pressed("camera_drag_move"):
		is_mouse_moving = true
	elif event.is_action_released("camera_drag_move"):
		is_mouse_moving = false
		camera_mouse_movement_direction = Vector3.ZERO
	if event is InputEventMouseMotion and is_mouse_moving:
		camera_mouse_movement_direction = Vector3(event.relative.x, 0, event.relative.y)


func camera_move(delta: float) -> void:
	if !camera_base_can_move:
		return
	
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("camera_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("camera_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("camera_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("camera_right"):
		direction += transform.basis.x
	
	position += direction.normalized() * camera_base_move_speed * delta


func camera_drag_move(delta: float) -> void:
	# TODO - Update this to work dynamically based on camera rotation
	if !camera_base_can_move or !is_mouse_moving:
		return
	var direction: Vector3 = Vector3.ZERO
	direction -= camera_mouse_movement_direction
	position += direction.normalized() * camera_drag_move_speed * delta


func camera_zoom(delta: float) -> void:
	if !camera_can_zoom:
		return
	
	var zoom_position: float = clamp(camera.position.z + camera_zoom_speed * camera_zoom_direction * delta, camera_zoom_minimum, camera_zoom_maximum)
	camera.position.z = zoom_position
	camera_zoom_direction *= camera_zoom_dampening

# Moves the camera as the mouse hits the edge of the viewport
func camera_edge_pan(delta: float) -> void:
	if !camera_can_edge_pan:
		return
	
	var viewport_current: Viewport = get_viewport()
	var pan_direction: Vector2 = Vector2(-1, -1)
	var viewport_visible_rectangle: Rect2i = Rect2i(viewport_current.get_visible_rect())
	var viewport_size: Vector2i = viewport_visible_rectangle.size
	var current_mouse_position: Vector2 = viewport_current.get_mouse_position()
	var zoom_factor: float = camera.position.z * 0.1
	
	# Left/right edge pan
	if (current_mouse_position.x < edge_pan_margin) or (current_mouse_position.x > viewport_size.x - edge_pan_margin):
		if current_mouse_position.x > viewport_size.x / 2.0:
			pan_direction.x = 1
		translate(Vector3(pan_direction.x * edge_pan_speed * zoom_factor * delta, 0, 0))
	
	# Top/bottom edge pan
	if (current_mouse_position.y < edge_pan_margin) or (current_mouse_position.y > viewport_size.y - edge_pan_margin):
		if current_mouse_position.y > viewport_size.y / 2.0:
			pan_direction.y = 1
		translate(Vector3(0, 0, pan_direction.y * edge_pan_speed * zoom_factor * delta))


# Rotates the camera position
func camera_rotation(delta: float) -> void:
	if !camera_base_can_rotate or !is_rotating:
		return
	rotate_camera_base(delta, camera_rotation_direction * camera_base_rotation_speed)


func rotate_camera_base(delta: float, direction: float) -> void:
	rotation.y += direction * delta


func rotate_to_mouse_offset(delta: float) -> void:
	if !rotate_to_mouse_offset or !is_mouse_rotating:
		return
	
	var mouse_offset: Vector2 = get_viewport().get_mouse_position() - last_mouse_position
	last_mouse_position = get_viewport().get_mouse_position()
	
	rotate_camera_base(delta, mouse_offset.x)
	rotate_camera_socket(delta, mouse_offset.y)


func rotate_camera_socket(delta: float, direction: float) -> void:
	if !camera_socket_can_rotate:
		return
	
	var new_rotation_x: float = camera_socket.rotation.x - (direction * camera_base_rotation_speed * delta)
	new_rotation_x = clamp(new_rotation_x, camera_socket_rotation_minimum, camera_socket_rotation_maximum)
	camera_socket.rotation.x = new_rotation_x
