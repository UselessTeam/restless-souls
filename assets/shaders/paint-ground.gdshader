shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise: hint_default_white;
uniform sampler2D noise_colors: hint_default_white;
varying vec2 position;
const vec2 VARIATION_SPEED = vec2(0.00025, 0.0003);

void vertex() {
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	position = VERTEX;
}

void fragment() {
	vec2 offset = fract(VARIATION_SPEED * position.xy);
	vec2 noised = texture(noise, offset).xy;
	COLOR.rgb = COLOR.rgb * texture(noise_colors, noised).rgb;
	COLOR.a = clamp(mix(-0.5, 1.2, COLOR.a), 0., 1.);
}