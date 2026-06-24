shader_type spatial;
render_mode unshaded;

uniform vec3 color = vec3(1,1,1);
uniform float rim_intensity = 0.5;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment()
{
	float basic_fresnel = fresnel(rim_intensity, NORMAL, VIEW);
	ALBEDO = color.rgb;
	ALPHA = basic_fresnel;
}
