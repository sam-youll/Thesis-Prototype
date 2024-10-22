extends MeshInstance3D

#Geometry Variables
var center_pos: Vector3
var radius = 1
var subdivisions = 8
var circle_centers := []

# Called when the node enters the scene tree for the first time.
func extend_rail() -> void:
	#create the array and give it length
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	#create the arrays for each type
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	#Geometry (AAA) 
	for i in subdivisions:
		var theta = i * 2 * PI / subdivisions
		var vert_x = tan(theta) * radius
		var vert_y = sin(theta) * radius
		var vert: Vector3 = Vector3(vert_x, vert_y, center_pos.z)
		
		verts.append(vert)
		normals.append(vert.normalized())
		uvs.append(Vector2(i/subdivisions, theta))
		
		if i < (subdivisions - 1): 
			indices.append(i + 2)
			indices.append(i + 1)
			indices.append(0)
		
	
	#Creating the mesh 
	surface_array[Mesh.ARRAY_VERTEX]
	surface_array[Mesh.ARRAY_TEX_UV]
	surface_array[Mesh.ARRAY_MAX]
	surface_array[Mesh.ARRAY_INDEX]
	
	#Commit mesh
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
