shader_type canvas_item;

const float MIN_SUIT = 0.4;
const float MAX_DIST = 0.1;
const float BLEND_FACTOR = 0.5;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float r = tex_color.r;
    float g = tex_color.g;
    float b = tex_color.b;

    bool brightish = (r >= MIN_SUIT) && (g >= MIN_SUIT) && (b >= MIN_SUIT);
    bool sim_colors = (abs(r - g) <= MAX_DIST) && (abs(g - b) <= MAX_DIST) && (abs(r - b) <= MAX_DIST);

    if (brightish && sim_colors) {
        vec3 blue_tint = vec3(0.0, 0.0, 1.0);
        tex_color.rgb = mix(tex_color.rgb, blue_tint, BLEND_FACTOR);
    }

    COLOR = tex_color;
}
