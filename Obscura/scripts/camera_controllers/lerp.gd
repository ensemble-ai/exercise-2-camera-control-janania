extends CameraControllerBase

@export var follow_speed: float  
@export var catchup_speed: float 
@export var leash_distance: float  


func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_cross()
	
	follow_target(delta)
	super(delta)

func follow_target(delta: float):
	var tpos = target.global_position
	var cpos = global_position
	
	var dist = (tpos - cpos).length() #distance
	var dir = (tpos - cpos).normalized() #direction
	
	if dist > leash_distance:
		if target.velocity.length() > 0:
			global_position += dir * follow_speed * delta
		else:
			global_position += dir * catchup_speed * delta
	else:
		global_position += dir * (target.BASE_SPEED) * delta 

func draw_cross():
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -5 / 2
	var right:float = 5 / 2
	var top:float = -5 / 2
	var bottom:float = 5 / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0,top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
