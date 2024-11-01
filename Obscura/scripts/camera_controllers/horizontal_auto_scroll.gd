extends CameraControllerBase

@export var top_left: Vector2  
@export var bottom_right: Vector2  
@export var autoscroll_speed: Vector3 
var box_width : float
var box_height : float

func _ready() -> void:
	box_width = (bottom_right.x - top_left.x) 
	box_height = (bottom_right.y - top_left.y) 
	
func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_frame_border()
	
	#update both x and z since autoscroll is in the direction of x-z plane
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta
	
	handle_target_movement(box_width, box_height)

	super(delta)

func handle_target_movement(box_width, box_height) -> void:
	var tpos = target.global_position
	var cpos = global_position
	
	var box_width_half = box_width / 2
	var box_height_half = box_height / 2
	var target_width_half = target.WIDTH / 2
	var target_height_half = target.HEIGHT / 2


	#left edge 
	var box_left = cpos.x - box_width_half
	var target_left = tpos.x - target_width_half
	
	if target_left < box_left:
		target.global_position.x +=  box_left - target_left 
	
	#right edge
	var box_right = cpos.x + box_width_half
	var target_right= tpos.x + target_width_half
	
	if target_right > box_right:
		target.global_position.x -= target_right - box_right
	
	#top edge
	var box_top = cpos.z - box_height_half
	var target_top = tpos.z - target_height_half
	
	if target_top < box_top:
		target.global_position.z += box_top - target_top
		
	#bottom edge
	var box_bottom = cpos.z + box_height_half
	var target_bottom = tpos.z + target_height_half
	
	if target_bottom > box_bottom:
		target.global_position.z -= target_bottom - box_bottom

func draw_frame_border() -> void:
	var tpos = target.global_position
	var cpos = global_position
	
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
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
