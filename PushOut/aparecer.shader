shader_type canvas_item;

uniform float alpha;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	//COLOR = vec4(UV, 1.0, 1.0);
	//COLOR.rgb = vec3(0.0, alpha, 0.0);
	COLOR.a *= alpha;
}