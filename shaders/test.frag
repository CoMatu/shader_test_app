#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float iTime;

out vec4 fragColor;

void main() {
    vec2 iResolution = uSize;
    vec2 fragCoord = FlutterFragCoord();

    vec2 sp = fragCoord.xy / iResolution;
    vec3 color = cos(iTime + sp.xyx + vec3(0, 1, 5));
    fragColor = vec4(color, 1);
}