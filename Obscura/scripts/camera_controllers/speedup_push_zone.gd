extends CameraControllerBase

@export var push_ratio : float
@export var pushbox_top_left: Vector2
@export var pushbox_bottom_right : Vector2
@export var speedup_zone_top_left : Vector2
@export var speedup_zone_bottom : Vector2

var outer_box_width : float
var outer_box_height : float
var inner_box_height : float
var inner_box_width : float

var target_width_half : float
var target_height_half : float

var inner_width_half : float
var inner_height_half : float

var outer_width_half : float
var outer_height_half : float

var tpos: Vector3
var cpos: Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outer_box_width = pushbox_bottom_right.x * 2
	outer_box_height = pushbox_bottom_right.y * 2
	
	inner_box_width = speedup_zone_bottom.x * 2
	inner_box_height = speedup_zone_bottom.y * 2
	
	target_width_half = target.WIDTH / 2
	target_height_half = target.HEIGHT / 2

	inner_width_half = inner_box_width / 2
	inner_height_half = inner_box_height / 2

	outer_width_half = outer_box_width / 2
	outer_height_half = outer_box_height / 2

func _process(delta: float) -> void:
	if !current:
		return 
	
	handle_target_movement(delta)
	
	if draw_camera_logic:
		draw_frame_border(-outer_box_width/2, outer_box_width/2, outer_box_height/2, -outer_box_height/2)
		draw_frame_border(-inner_box_width/2, inner_box_width/2, inner_box_height/2, -inner_box_height/2)
	super(delta)
	
func handle_target_movement(delta) -> void:
	var tpos = target.global_position
	var cpos = global_position
	
	var diff_between_left_edges = (tpos.x - target_width_half) - (cpos.x - outer_width_half)
	var diff_between_right_edges = (tpos.x + target_width_half) - (cpos.x + outer_width_half)
	var diff_between_top_edges = (tpos.z - target_height_half) - (cpos.z - outer_height_half)
	var diff_between_bottom_edges = (tpos.z + target_height_half) - (cpos.z + outer_height_half)
	
	var touching_left = (diff_between_left_edges <= 0)
	var touching_right = (diff_between_right_edges >= 0)
	var touching_top = (diff_between_top_edges <= 0)
	var touching_bottom = (diff_between_bottom_edges >= 0)
	
	var dir = target.velocity.normalized()
	var speed = target.velocity.length()
	
	if touching_left and touching_top:
		global_position.x += diff_between_left_edges
		global_position.z += diff_between_top_edges
	elif touching_right and touching_top:
		global_position.x += diff_between_right_edges
		global_position.z += diff_between_top_edges
	elif touching_left and touching_bottom:
		global_position.x += diff_between_left_edges
		global_position.z += diff_between_bottom_edges
	elif touching_right and touching_bottom:
		global_position.x += diff_between_right_edges
		global_position.z += diff_between_bottom_edges
	elif touching_left:
		global_position.x += diff_between_left_edges
		if target.velocity.z < 0:
			global_position.z -= speed * push_ratio * delta
		if target.velocity.z > 0:
			global_position.z += speed * push_ratio * delta
	elif touching_right:
		global_position.x += diff_between_right_edges
		if target.velocity.z < 0:
			global_position.z -= speed * push_ratio * delta
		if target.velocity.z > 0:
			global_position.z += speed * push_ratio * delta
	elif touching_top:
		global_position.z += diff_between_top_edges
		if target.velocity.x < 0:
			global_position.x -= speed * push_ratio * delta
		if target.velocity.x > 0:
			global_position.x += speed * push_ratio * delta
	elif touching_bottom:
		global_position.z += diff_between_bottom_edges
		if target.velocity.x < 0:
			global_position.x -= speed * push_ratio * delta
		if target.velocity.x > 0:
			global_position.x += speed * push_ratio * delta
	elif is_within_speedup_zone():
		global_position += dir * speed * push_ratio * delta
		
func is_within_speedup_zone() -> bool:
	var cpos = global_position
	var target_left = target.position.x - target_width_half
	var target_right = target.position.x + target_width_half
	var target_top = target.position.z - target_height_half
	var target_bottom = target.position.z + target_height_half

	var in_outer_box = (
		target_left > cpos.x - outer_width_half and
		target_right < cpos.x + outer_width_half and
		target_top > cpos.z - outer_height_half and
		target_bottom < cpos.z + outer_height_half)
	var outside_inner_box = (
		target_left < cpos.x - inner_width_half or
		target_right > cpos.x + inner_width_half or
		target_top < cpos.z - inner_height_half or
		target_bottom > cpos.z + inner_height_half)

	return in_outer_box and outside_inner_box

func draw_frame_border(left: float, right: float, top: float, bottom: float) -> void:
	var tpos = target.global_position
	var cpos = global_position
	
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
