shader_type spatial;
render_mode skip_vertex_transform, shadows_disabled, cull_disabled, unshaded;
uniform vec4 ribbonColor : source_color;
uniform sampler2D ribbonTexture;
uniform sampler2D ribbonTextureSec;
// all parameters inside data parameters are used by ribbon system and not meant to be edited manually
group_uniforms DataParameters;
uniform sampler2D texData : filter_nearest, repeat_disable;
uniform vec2 texDataSize = vec2(64.0, 64.0); // this should be static but need to be edited as param
//const int maxPoints = 64;
//uniform vec3 ribbonPos[maxPoints];
//uniform mat3 ribbonRot[maxPoints];
//uniform float ribbonUX[maxPoints];

instance uniform int posID;
instance uniform int rotID;
instance uniform int norID;
instance uniform int segID;


void vertex() {
	//int id = int(UV2.x);
	//vec3 world = local + ribbonPos[id];
	// rotate first
	//vec3 local = ribbonRot[id] * VERTEX;
	vec2 uv;
	// construct mat3 from the pixel data (id +1 to 3)
	uv = (vec2(UV2.x, float(rotID)) + 0.5) / texDataSize;
	vec3 vmx =  texture(texData, uv).rgb;
	uv = (vec2(UV2.x, float(rotID+1)) + 0.5) / texDataSize;
	vec3 vmy =  texture(texData, uv).rgb;
	uv = (vec2(UV2.x, float(rotID+2)) + 0.5) / texDataSize;
	vec3 vmz =  texture(texData, uv).rgb;
	mat3 cmat = mat3(vmx, vmy, vmz);
	vec3 local = cmat * VERTEX;
	// then set the world position
	uv = (vec2(UV2.x, float(posID)) + 0.5) / texDataSize;
	vec3 world = local + texture(texData, uv).rgb;
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(world, 1.0);
	//UV = vec2(ribbonUX[id],UV.y);
	uv = (vec2(UV2.x, float(segID)) + 0.5) / texDataSize;
	UV = vec2(texture(texData, uv).r, UV.y); // only R used
}

void fragment() {
	vec4 prim = texture(ribbonTexture, UV);
	vec4 sec = texture(ribbonTextureSec, UV);
    ALBEDO = ribbonColor.rgb * prim.rgb * sec.rgb;
    ALPHA = ribbonColor.a * prim.a * sec.a;
}
