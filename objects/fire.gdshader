shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = UV;

    // Discard pixels based on progress, revealing from right to left
    if (uv.x > progress) {
        discard;
    }

    COLOR = texture(TEXTURE, uv);
}
