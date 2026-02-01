shader_type canvas_item;
uniform bool look_right = true;
uniform float skew_dir = 1.0;
uniform float profile = 1.0;

void vertex() {
	VERTEX.x = VERTEX.x * { -1.0, 1.0 }[int(look_right)];
	
	float base_weight = mix(1.0, (1.0 - UV.y), clamp(profile, 0.0, 1.0));
	
	float xSkewRatio = step(UV.y, .5);
	vec2 skewTransition = vec2(skew_dir * abs(VERTEX.x) * xSkewRatio * base_weight, 0.0);
	vec2 skewScale = vec2(VERTEX.x, (VERTEX.y + abs(VERTEX.y)) / 2.0);
	
	VERTEX = skewScale;
	VERTEX = VERTEX + skewTransition;
}

void fragment() {
	COLOR = vec4(vec3(.0), .5 * COLOR.a); // moltiplico per COLOR.a perché altrimenti prenderebbe tutto il bounding box della texture
}