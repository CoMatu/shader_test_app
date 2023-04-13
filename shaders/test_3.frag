#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float iTime;                 // shader playback time (in seconds) 3
uniform sampler2D image1;          // input channel. XX = 2D/Cube
uniform sampler2D image2;          // input channel. XX = 2D/Cube

out vec4 fragColor;


float rand(vec2 co) {
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
    vec2 iResolution = uSize;
    vec2 fragCoord = FlutterFragCoord();

    float threshold = 3.;
    float fadeEdge = 0.1;
    vec2 center = vec2(0.5);


    float iTime2 = fract(iTime/4.);
    vec2 uv = fragCoord/iResolution.xy;
    float dist = distance(center, uv) / threshold;
    float r = iTime2 - min(rand(vec2(uv.y, 0.0)), rand(vec2(0.0, uv.x)));
    vec4 c1 = texture(image1,uv);
    vec4 c2 = texture(image2,uv);

    fragColor = mix(c1, c2, mix(0.0, mix(step(dist, r), 1.0, smoothstep(1.0-fadeEdge, 1.0, iTime2)), smoothstep(0.0, fadeEdge, iTime2)));
}