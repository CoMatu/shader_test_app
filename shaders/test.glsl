uniform float iTime;
uniform vec2 iResolution;
out vec4 fragColor;


void main() {
    vec2 sp = gl_FragCoord.xy / iResolution;
    vec3 color = cos(iTime + sp.xyx + vec3(0, 1, 5));
    fragColor = vec4(color, 1);
}