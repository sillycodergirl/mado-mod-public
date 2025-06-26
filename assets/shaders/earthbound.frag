// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

const vec3 mainColor = vec3(.6, .0, 136./255.);

float sawtooth(float a, float freq) {
    if (mod(a, freq) < freq * 0.5) return mod(a, freq * 0.5);
    return freq * 0.5 - mod(a, freq * 0.5);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    float resolutionRatio = iResolution.x / iResolution.y;
    
    // uv fuckery !
    // pixelate
    
    float pxAmt = 75.0;
    
    uv.x = floor(uv.x * pxAmt) / pxAmt;
    uv.y = floor(uv.y * pxAmt) / pxAmt;
    
    // interlacing .
    float pixAmt = 2.0;
    if (mod(fragCoord.y, pixAmt) < pixAmt * 0.5) {
        uv += 0.1 + sin(iTime * 0.2 + uv.y * 8.) * 0.05;
    } else {
        uv -= 0.1 + sin(iTime * 0.2 + uv.y * 8. + .5) * 0.05;
    }
    
    vec2 uv2 = uv;
    
    vec3 color = vec3(0.1);
    
    // first one (bg-ish thing??)
    
    color = vec3(mod(abs(sawtooth(uv.x, 0.6) * resolutionRatio + sawtooth(uv.y, 0.6) + iTime * 0.3), 0.4)) * mainColor;
    
    // second one (stripes-like thing)
    
    if (uv2.x < 0.5) {
        uv2.x = 1.0 - uv2.x;
    }
    if (uv2.y > 0.5) {
        uv2.y = 1.0 - uv2.y;
    }

    uv2.x += sin(uv2.y * 4.0 + iTime) * 0.1;
    
    if (mod(abs(uv2.x * resolutionRatio + uv2.y + iTime * 0.2), 0.2) < 0.1) {
        vec3 lines = vec3(cos(uv.x * 2.0 + iTime + uv.y * 3.0)) * mainColor * 0.7;
        color = mix(color, lines, 0.3);
    }
    
    // color shortening
    // gives it a kind of like snes-like palette
    float shortAmt = 10.0;
    color = ceil(color * shortAmt) / shortAmt;
    
    // feed the frag color .
    fragColor = vec4(color, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}