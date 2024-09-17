extends MeshInstance3D

var surface_array := []

func set_deformable_mesh(mesh_array: Array) -> void:
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var verts := PackedVector3Array()
	var uvs := PackedVector2Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()

	# Vertex indices.
	var thisrow := 0
	var prevrow := 0
	var point := 0

	# Loop over width (x)
	for x in mesh_array.size():
		# Loop over length (z)
		for z in mesh_array.size():
			var vert_x := float(x)/2 - 128 + .5
			var vert_z := float(z)/2 - 128 + .5
#			var vert := Vector3(vert_x, 3 * sin(x * .2) * cos(z * .2), vert_z)
			var vert := Vector3(vert_x, mesh_array[x][z], vert_z)
			verts.append(vert)
			normals.append(vert.normalized())
#			normals.append(Vector3.UP)
			uvs.append(Vector2(float(vert_x), float(vert_z)))
			point += 1
		
			# Create triangles using indices
			if x > 0 and z > 0:
				indices.append(thisrow + z - 1)
				indices.append(prevrow + z)
				indices.append(prevrow + z - 1)

				indices.append(thisrow + z - 1)
				indices.append(thisrow + z)
				indices.append(prevrow + z)
		
		prevrow = thisrow
		thisrow = point

	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh.regen_normal_maps()
	print(surface_array[Mesh.ARRAY_VERTEX].size())
	
func update_deformable_mesh(mesh_array: Array, epicenter: Vector2) -> void:
	for x in mesh_array.size():
		for z in mesh_array.size():
			var mx = epicenter.x - mesh_array.size()/2
			var mz = epicenter.y - mesh_array.size()/2
			if !mesh_array.is_empty() and mx >= 0 and mz >= 0:
				surface_array[Mesh.ARRAY_VERTEX][mx + (mz * 512)].y = mesh_array[x][z]
	
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh.regen_normal_maps()
	
#	var mdt = MeshDataTool.new()
#	mdt.create_from_surface(mesh, 0)
#	for i in mdt.get_vertex_count():
#		var vert = mdt.get_vertex(i)
#		var x = vert.x * 2 + 127.5
#		var z = vert.z * 2 + 127.5
#		vert = Vector3(vert.x, mesh_array[x][z], vert.z)
#		mdt.set_vertex(i, vert)
#	mesh.clear_surfaces()
#	mdt.commit_to_surface(mesh)
