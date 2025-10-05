shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise: hint_default_white;
uniform sampler2D noise_colors: hint_default_white;
varying vec2 position;
const vec2 VARIATION_SPEED = vec2(0.001, 0.0013);

void vertex() {
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	position = VERTEX;
}

void fragment() {
    // COLOR = texture(TEXTURE, UV);
	// COLOR = COLOR * texture(noise, position);
	vec2 offset = fract(VARIATION_SPEED * position.xy);
	vec2 noised = texture(noise, offset).xy;
	COLOR.rgb = COLOR.rgb * texture(noise_colors, noised).rgb;
	COLOR.a = clamp(mix(-0.5, 1.2, COLOR.a), 0., 1.);
}
// void fragment() {
//     vec2 uv = FRAGCOORD.xy / vec2(textureSize(SCREEN_TEXTURE, 0));
    
//     vec4 screen_color = texture(SCREEN_TEXTURE, uv);
//     float noise_value = texture(noise, uv).r;
//     vec4 final_color = screen_color * noise_value;
//     COLOR = final_color;
// }
