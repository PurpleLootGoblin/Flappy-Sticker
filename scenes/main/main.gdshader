shader_type canvas_item;


uniform int octaves = 4;


uniform float starting_amplitude: hint_range(0.0, 0.5) = 0.5;


uniform float starting_frequency = 1.0;


uniform float shift: hint_range(-1.0, 0.0) = -0.2;


uniform vec2 velocity = vec2(1.0, 1.0);


uniform vec4 fog_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);


uniform sampler2D noise: repeat_enable;

float rand(vec2 uv) {
    float amplitude = starting_amplitude;
    float frequency = starting_frequency;
    float output = 0.0;
    for (int i = 0; i < octaves; i++) {
        output += texture(noise, uv * frequency).x * amplitude;
        amplitude /= 2.0;
        frequency *= 2.0;
    }
    return clamp(output + shift, 0.0, 1.0);
}

void fragment() {
    vec2 motion = vec2(rand(UV + TIME * starting_frequency * velocity));
    
    
    vec4 sprite_color = texture(TEXTURE, UV);
    
    
    bool is_black = sprite_color.rgb.r < 0.01 && sprite_color.rgb.g < 0.01 && sprite_color.rgb.b < 0.01;
    bool is_white = sprite_color.rgb.r > 0.99 && sprite_color.rgb.g > 0.99 && sprite_color.rgb.b > 0.99;
    
    
    if (is_black || is_white) {
        COLOR = sprite_color;
    } else {
        
        float alpha = sprite_color.a;
        vec3 final_color = mix(sprite_color.rgb, fog_color.rgb, rand(UV + motion));
        vec3 blended_color = mix(sprite_color.rgb, final_color, dot(sprite_color.rgb, vec3(0.2126, 0.7152, 0.0722)));
        COLOR.rgb = blended_color;
        COLOR.a = alpha;
    }
}
