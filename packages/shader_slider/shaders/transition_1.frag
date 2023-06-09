// inspired by shader from VoidChicken
// https://www.shadertoy.com/view/XtdXR2
// ... and portal of course ;)

// смена изображений сдвигом квадратиков
#include <flutter/runtime_effect.glsl>

// 1 .. 3
#define TRANSITION_TYPE 1

uniform vec2 uSize;
uniform float iTime;                 // shader playback time (in seconds) 3
uniform sampler2D image1;          // input channel. XX = 2D/Cube
uniform sampler2D image2;          // input channel. XX = 2D/Cube

out vec4 fragColor;


vec2 plane(vec3 p, vec3 d, vec3 normal)
{
    vec3 up = vec3(0,1,0);
    vec3 right = cross(up, normal);
    
    float dn = dot(d, normal);
    float pn = dot(p, normal);
    
    vec3 hit = p - d / dn * pn;
    
    vec2 uv;
    uv.x = dot(hit, right);
    uv.y = dot(hit, up);
    
    return uv;
}

void main()
{
     vec2 iResolution = uSize;
     vec2 fragCoord = FlutterFragCoord();


//     vec2 uv = fragCoord.xy / iResolution.xy;
//     float dur = 2.;
//     float dim = 7.;
//     vec2 v = uv;
//     v.y=1.-v.y;
//     vec2 x = mod(1.-v.xx, 1./dim)+floor(v*dim)/dim;
//     float a = .5*(abs(x.x)+abs(x.y));
//     float b = fract(iTime/dur);
//     a=a>b?0.:1.;
//     bool mt = mod(floor(iTime/dur),2.)==0.;
//     float cd = a;
//     if (mt)
//     {
//     	cd=1.-cd;    
//     }
// fragColor = mix(vec4(a),(mix(texture(image1, uv), texture(image2, uv), cd)), 1.0);

    vec2 xy = fragCoord - iResolution.xy / 2.0;
    float grid_width = 64.0;
    xy /= grid_width;
    vec2 grid = floor(xy);
    xy = mod(xy, 1.0) - 0.5;
    
    float alpha = 0.0;//iMouse.x / iResolution.x;
    float offset = (grid.y - grid.x)*0.1;
    float time = iTime*1.0 - offset;
#if TRANSITION_TYPE == 1
    // looping + wrapping
    time = mod(time, 6.0);
#elif TRANSITION_TYPE == 2
    // flip once
    time = clamp(time - 1., 0., 1.);
#elif TRANSITION_TYPE == 3
    // flip and return once
#endif
    alpha += smoothstep(0.0, 1.0, time);
    alpha += 1.0 - smoothstep(3.0, 4.0, time);
    alpha = abs(mod(alpha, 2.0)-1.0);
    
    float side = step(0.5, alpha);
    
    alpha = radians(alpha*180.0);
    vec4 n = vec4(cos(alpha),0,sin(alpha),-sin(alpha));
    vec3 d = vec3(1.0,xy.y,xy.x);
    vec3 p = vec3(-1.0+n.w/4.0,0,0);
    vec2 uv = plane(p, d, n.xyz);
    
    uv += 0.5;
    if (uv.x<0.0||uv.y<0.0||uv.x>1.0||uv.y>1.0)
    {
        fragColor *= 0.0;
        return;
    }
    
    vec2 guv = grid*grid_width/iResolution.xy+0.5;
    vec2 scale = vec2(grid_width)/iResolution.xy;
    vec4 c1 = texture(image1, guv + vec2(1.0-uv.x,uv.y)*scale);
    vec4 c2 = texture(image2, guv + vec2(uv.x,uv.y)*scale);
    
    fragColor = mix(c1, c2, side);

}