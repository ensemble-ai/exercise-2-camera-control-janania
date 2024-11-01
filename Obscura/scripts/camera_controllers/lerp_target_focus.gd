extends CameraControllerBase

@export var lead_speed: float 
@export var catchup_delay_duration: float  
@export var catchup_speed: float  
@export var leash_distance: float 

var offset_position = Vector2.ZERO
var tstopped: float = 0.0

func _ready():
	lead_speed = target.BASE_SPEED + 5
	catchup_speed = target.BASE_SPEED
	catchup_delay_duration = 0.2
	leash_distance = 12

func _process(delta: float) -> void:
	if !current:
		return

	follow_target_forward(delta)

	if draw_camera_logic:
		draw_cross()
	super(delta)

func follow_target_forward(delta: float):
	var tpos = target.global_position
	var cpos = global_position
	var dir = target.velocity.normalized()
	var dist = (tpos - cpos).length()
	var target_speed = target.velocity.length() 
	
	#keep count of how long target is idle and add delta time 
	#to tstopped which how long it has been since target has stopped
	if target_speed == 0:
		tstopped += delta
	else:
		tstopped = 0
	
	if dist < leash_distance:
		if target.velocity.length() == 0 and tstopped >= catchup_delay_duration:
			global_position += (tpos - cpos).normalized() * catchup_speed * delta
		elif target.velocity.length() > 0:
			offset_position = dir * lead_speed
			global_position += offset_position * delta
	else:
		global_position += (tpos - cpos).normalized() * catchup_speed * delta
		
func draw_cross():
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var half_size: float = 2.5
	var left: float = -half_size
	var right: float = half_size
	var top: float = -half_size
	var bottom: float = half_size
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()
