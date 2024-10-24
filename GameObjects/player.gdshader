shader_type canvas_item;

const float MIN_SUIT = 0.6;
const float MAX_DIST = 0.06;
const float BLEND_FACTOR = 0.5;

uniform vec3 tint;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float r = tex_color.r;
    float g = tex_color.g;
    float b = tex_color.b;

    bool skin = (r >= MIN_SUIT) && (g >= MIN_SUIT) && (b >= MIN_SUIT);
    bool sim_colors = (abs(r - g) >= MAX_DIST) && (abs(r - b) >= MAX_DIST);

    if (!(skin && sim_colors)) {
        tex_color.rgb = mix(tex_color.rgb, tint, BLEND_FACTOR);
    }

    COLOR = tex_color;
}
