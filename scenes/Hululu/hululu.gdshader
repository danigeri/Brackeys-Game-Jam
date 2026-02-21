shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform float wave_intensity : hint_range(0.0, 0.1) = 0.0;
uniform float noise_strength : hint_range(0.0, 0.05) = 0.0;

uniform float wave_frequency : hint_range(1.0, 30.0) = 8.0;
uniform float wave_speed : hint_range(0.1, 5.0) = 1.2;
uniform vec4 dream_tint : source_color = vec4(0.75, 0.85, 1.0, 1.0); // cool blue-white stolen randomly
uniform float tint_strength : hint_range(0.0, 1.0) = 0.3;
uniform float brightness : hint_range(0.5, 2.0) = 1.1;
uniform float vignette : hint_range(0.0, 1.0) = 0.6;

void fragment() {
    vec2 uv = SCREEN_UV;
    float t = TIME * wave_speed;
    // sexy random waves
    float wx = sin(uv.y * wave_frequency       + t * 0.9) * wave_intensity;
    float wy = cos(uv.x * wave_frequency * 0.8 + t * 1.1) * wave_intensity;
    wx += sin(uv.y * wave_frequency * 2.1 + t * 0.5 + 1.3) * wave_intensity * 0.45;
    wy += cos(uv.x * wave_frequency * 1.6 + t * 0.7 + 2.7) * wave_intensity * 0.45;

    // rgb split i guess
    vec2 distorted = uv + vec2(wx, wy);
    vec2 ca = vec2(noise_strength, 0.0);
    float r = texture(screen_texture, distorted + ca).r;
    float g = texture(screen_texture, distorted      ).g;
    float b = texture(screen_texture, distorted - ca).b;
    vec4 color = vec4(r, g, b, 1.0);

    // this is the tint shit 
    float effect_amount = clamp(wave_intensity / 0.05, 0.0, 1.0);
    //color.rgb = mix(color.rgb, color.rgb * dream_tint.rgb, tint_strength * effect_amount);
	color.rgb = mix(color.rgb, dream_tint.rgb, tint_strength * effect_amount);


    // im not sure we need these 
    // color.rgb *= mix(1.0, brightness, effect_amount); // brigntess shit?
    //vec2 vig_uv = uv * (1.0 - uv); // vignette
    //float vig = pow(vig_uv.x * vig_uv.y * 16.0, vignette * effect_amount);// vignette
    //color.rgb *= clamp(vig, 0.0, 1.0); // vignette

    // yes sir
    COLOR = vec4(color.rgb, 1.0);
}
