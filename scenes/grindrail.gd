extends MeshInstance3D
class_name Grindrail

#Geometry Variables
var center_pos: Vector3
var radius = 1
var subdivisions = 4
var circle_centers := []

@export var grindrail_material: Material

# Called when the node enters the scene tree for the first time.
func extend_rail(circle_center: Vector3) -> void:
	#adding player pos
	circle_centers.append(circle_center)
	print(circle_centers.size())
	#create the array and give it length
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	#create the arrays for each type
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	#this/prev circle
	var this_circle = 0
	var previous_circle = 0
	
	#Geometry (AAA) 
	for circle in circle_centers.size():
		for i in subdivisions:
			var theta = i * 2 * PI / subdivisions
			var vert_x = tan(theta) * radius
			var vert_y = sin(theta) * radius
			var vert: Vector3 = Vector3(vert_x, vert_y, center_pos.z)
			
			print(vert)
			
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(i/subdivisions, theta))

			if circle == 0:
				indices.append(i + 2)
				indices.append(i + 1)
				indices.append(0)
			else:
				#first triangle
				indices.append(i + previous_circle * subdivisions)
				indices.append(i + 1 + previous_circle * subdivisions)
				indices.append(i + this_circle * subdivisions)
				#second triangle
				indices.append(i + 1 + previous_circle * subdivisions)
				indices.append(i + 1 + this_circle * subdivisions)
				indices.append(i + this_circle * subdivisions)
				
				#new circle
				previous_circle = this_circle 
				this_circle += 1
	
	
	#Creating the mesh 
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	#clear surfaces
	mesh.clear_surfaces()
	
	#Commit mesh
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	mesh.surface_set_material(0, grindrail_material)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
