# all comented array is previous version before using texture, I keep it to make it easy to understand

@icon("uid://bmu3rsmb04e6t")
class_name BRibbon extends MeshInstance3D

static var maxInstanceCount : int = 10

## set it empty if you want to track the parent instead
@export var objToTrack : Node3D
## the width of the ribbon
@export_range(.01, 100.0) var ribbonWidth : float = 1.0
## limited to 64 but can be edited, keep the maximum to be power of 2
## editing the maximum value at runtime is purposelly not allowed due to require vram re-allocations
@export_range(2, 64) var segmentCounts : int = 8
@export var segmentLength : float = 1.0
@export var updateDelta : float = 1.0
@export var enableShrink : bool = true
## editing this value should use setInstanceID(), look at setInstanceID() function for the detail
var instanceID : int = 0
var posID : int
var rotID : int
var norID : int
var segID : int
#var runtimePos : Array[Vector3]
#var runtimeRot : Array[Basis]
#var runtimeUX : Array[float]
var runtimeDelta : float = 0.0

static var imgData : Image
static var texData : Texture2D

var debugMeshes : Array[MeshInstance3D]

@export var drawDebugPoints : bool = false



## TOOLS START just to make the logic more readable

func getPowerOf32(value : int, increment : int) -> int:
	var x : float = floor(32.0 / float(increment))
	return int(ceil(float(value) / x)) * 32

func colorToVector(col : Color) -> Vector3:
	return Vector3(col.r, col.g, col.b)

func matrixToPixel(idX : int, startY : int, mat: Basis, img : Image) -> void:
	var mv : Color = Color(mat.x.x, mat.x.y, mat.x.z)
	img.set_pixel(idX, startY, mv)
	mv = Color(mat.y.x, mat.y.y, mat.y.z)
	img.set_pixel(idX, startY+1, mv)
	mv = Color(mat.z.x, mat.z.y, mat.z.z)
	img.set_pixel(idX, startY+2, mv)

func pixelToMatrix(idX : int, startY : int, img : Image) -> Basis:
	var mx : Vector3 = colorToVector(img.get_pixel(idX, startY))
	var my : Vector3 = colorToVector(img.get_pixel(idX, startY+1))
	var mz : Vector3 = colorToVector(img.get_pixel(idX, startY+2))
	return Basis(mx,my,mz)


## break matrix (Basis), converted to 3 pixels (id + 1 to 3)
func copyMatrixPixels(idFromX : int, idToX : int, startY : int, img : Image) -> void:
	var prevMatX : Color = img.get_pixel(idFromX, startY)
	var prevMatY : Color = img.get_pixel(idFromX, startY+1)
	var prevMatZ : Color = img.get_pixel(idFromX, startY+2)
	img.set_pixel(idToX, startY, prevMatX)
	img.set_pixel(idToX, startY+1, prevMatY)
	img.set_pixel(idToX, startY+2, prevMatZ)

func getTotalInstance() -> int:
	return get_tree().get_nodes_in_group("BRibbonInst").size()

## TOOLS END


## each ribbon instances need to have different id otherwise it will read wrong pixel data
## the id should be multiplied by 6, because the pixel data storage need 6 in y axis
## the data is: Position(vec3) = +0, Rotation(mat3) = +1,+2,+3, Normal(vec3) = +4, SegmentID(float, null, null) = +5
## the segmentID only use R channel, and GB are unused, can be used to send custom data from cpu to gpu without offsetting pixel-y
func setInstanceID(newID : int) -> void:
	instanceID = newID * 6
	posID = instanceID
	rotID = instanceID+1
	norID = instanceID+4
	segID = instanceID+5
	self.set_instance_shader_parameter("posID", posID)
	self.set_instance_shader_parameter("rotID", rotID)
	self.set_instance_shader_parameter("norID", norID)
	self.set_instance_shader_parameter("segID", segID)


func createMesh() -> void:
	var arrmesh = ArrayMesh.new()
	arrmesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, generate_strip().duplicate())
	mesh = arrmesh



func generate_strip() -> Array:
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	# all x increments required to be in 0.0, use comented code if needed for debugging
	#var v1 : Vector3 = self.global_position - (self.basis.y * ribbonWidth)
	#var v2 : Vector3 = self.global_position - (-self.basis.y * ribbonWidth)
	var v1 : Vector3 = self.basis.y * ribbonWidth
	var v2 : Vector3 = -v1
	
	var verts = PackedVector3Array()
	var indices = PackedInt32Array()
	var uvs = PackedVector2Array()
	var stripID = PackedVector2Array()
	var normals = PackedVector3Array()
	
	var uvXdelta : float = 1.0 / (float(segmentCounts) - 1.0)
	
	for i in range(0, segmentCounts * 2, 2):
		# all x increments required to be in 0.0, use comented code if needed for debugging
		#var incr : self.basis.x * segmentLength * i
		var incr : Vector3 = Vector3.ZERO
		var truei : float = float(i)/2.0
		verts.push_back(v1 + incr)
		verts.push_back(v2 + incr)
		# currently uv2 y is unused
		stripID.push_back(Vector2(truei, 0.0))
		stripID.push_back(Vector2(truei, 0.0))
		uvs.push_back(Vector2(uvXdelta * truei, 0))#Vector2(n, 1)
		uvs.push_back(Vector2(uvXdelta * truei, 1))#Vector2(n, 1)
		normals.push_back(-self.basis.z)
		normals.push_back(-self.basis.z)
		if i == 0: continue
		indices.push_back(i-2)
		indices.push_back(i-1)
		indices.push_back(i+0)
		indices.push_back(i+0)
		indices.push_back(i-1)
		indices.push_back(i+1)
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_INDEX] = indices
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_TEX_UV2] = stripID
	surface_array[Mesh.ARRAY_NORMAL] = normals
	return surface_array



func updateRuntime() -> void:
	for i in range(segmentCounts-1, 1, -1):
		#runtimePos[i] = runtimePos[i-1]
		var prevPos : Color = imgData.get_pixel(i-1, posID)
		imgData.set_pixel(i, posID, prevPos)
		#runtimeRot[i] = runtimeRot[i-1]
		# matrix need 3 vector3's so it splitted to 3 pixels in y axis
		copyMatrixPixels(i-1, i, rotID, imgData)
	#runtimePos[1] = runtimePos[0]
	#runtimePos[0] = self.global_position
	imgData.set_pixel(1, posID, imgData.get_pixel(0, posID))
	imgData.set_pixel(0, posID, Color(self.global_position.x, self.global_position.y, self.global_position.z))
	#runtimeRot[1] = runtimeRot[0]
	#runtimeRot[0] = self.global_transform.basis
	copyMatrixPixels(0, 1, rotID, imgData)
	matrixToPixel(0, rotID, self.global_transform.basis, imgData)
	

	# calculate uv.x based of overall distance
	# so if many points have same positions the uv.x spaced properly
	var utotal : float = 0.0
	for i in range(1, segmentCounts):
		#utotal += runtimePos[i-1].distance_to(runtimePos[i])
		var posa : Vector3 = colorToVector(imgData.get_pixel(i-1, posID))
		var posb : Vector3 = colorToVector(imgData.get_pixel(i, posID))
		utotal += posa.distance_to(posb)
	#runtimeUX[0] = 0.0
	imgData.set_pixel(0, segID, Color(0.0,0.0,0.0)) # only R are used
	var accumulated : float = 0.0
	for i in range(1, segmentCounts):
		#accumulated += runtimePos[i - 1].distance_to(runtimePos[i])
		var posa : Vector3 = colorToVector(imgData.get_pixel(i-1, posID))
		var posb : Vector3 = colorToVector(imgData.get_pixel(i, posID))
		accumulated += posa.distance_to(posb)
		#runtimeUX[i] = accumulated / utotal if utotal > 0.0 else 0.0
		imgData.set_pixel(i, segID, Color(accumulated / utotal if utotal > 0.0 else 0.0, 0.0, 0.0)) # only R are used
		
	
	texData.update(imgData)
	#self.material_override.set_shader_parameter("ribbonPos", runtimePos)
	#self.material_override.set_shader_parameter("ribbonRot", runtimeRot)
	#self.material_override.set_shader_parameter("ribbonUX", runtimeUX)



func debugInit() -> void:
	disableDebug()
	
	var sm : SphereMesh = SphereMesh.new()
	sm.height = 0.3
	sm.radius = 0.1
	var mi : MeshInstance3D
	
	for i in range(segmentCounts):
		mi = MeshInstance3D.new()
		mi.mesh = sm
		mi.position.x = updateDelta * i
		self.add_child(mi)
		mi.top_level = true
		debugMeshes.push_back(mi)



## just cleanup debug array, named disableDebug to more represent the functionality instead of the logic
func disableDebug() -> void:
	for dm in debugMeshes:
		if dm: dm.queue_free()
	debugMeshes.clear()



func debugUpdate() -> void:
	for i in range(debugMeshes.size()):
		if not debugMeshes[i]: continue
		#debugMeshes[i].global_position = runtimePos[i]
		#debugMeshes[i].global_transform.basis = runtimeRot[i]
		debugMeshes[i].global_position = colorToVector(imgData.get_pixel(i, posID))
		debugMeshes[i].global_transform.basis = pixelToMatrix(i, rotID, imgData)



func _enter_tree() -> void:
	self.add_to_group("BRibbonInst")
	self.top_level = true
	if not objToTrack: objToTrack = self.get_parent()
	createMesh()
	var resX : int = getPowerOf32(segmentCounts, 1)
	var resY : int = getPowerOf32(maxInstanceCount, 6) # 6 are total y pixels required each instances
	if texData == null:
		imgData = Image.create_empty(resX, resY, false, Image.FORMAT_RGBF)
		texData = ImageTexture.create_from_image(imgData)
	self.material_override.set_shader_parameter("texDataSize", imgData.get_size())
	#runtimePos.resize(segmentCounts)
	#runtimeRot.resize(segmentCounts)
	#runtimeUX.resize(segmentCounts)
	
	# using total instance to create instanceID. using -1 to make sure it start from 0
	setInstanceID(getTotalInstance() - 1)
	if instanceID == 0: print("BRibbon - imgData size: ", imgData.get_size()) # used for debugging only
	self.material_override.set_shader_parameter("texData", texData)
	if drawDebugPoints: debugInit()


func _exit_tree() -> void:
	# free static refcounted variables
	if getTotalInstance() == 1:
		imgData = null
		texData = null


func _process(delta) -> void:
	var dist : float = colorToVector(imgData.get_pixel(0, posID)).distance_to(objToTrack.global_position)
	if runtimeDelta < 0 or dist > segmentLength:
		self.global_transform = objToTrack.global_transform
		updateRuntime()
		debugUpdate() # automatically skipped when debugMeshes is empty
		runtimeDelta = updateDelta
	runtimeDelta -= delta * float(enableShrink)
