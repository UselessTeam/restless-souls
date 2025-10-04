// Assign this shader to your Sprite's material
shader_type canvas_item;

uniform vec4 key_color : source_color; // The color to make transparent
uniform float threshold : hint_range(0.0, 1.0) = 0.01;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    if (distance(tex.rgb, key_color.rgb) < threshold) {
        tex.a = 0.0;
    }
    COLOR = tex;
}