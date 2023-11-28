shader_type canvas_item;

uniform float amount : hint_range(0, 1) = 0.0;

void fragment() {
    COLOR.a = max(0.0, min(1.0, 1.0 - amount + UV.x - mix(0.0, 1.0, amount)));
}
