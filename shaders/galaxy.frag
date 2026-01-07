#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

// Hash function for pseudo-random values
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Spiral function
float spiral(vec2 p, float time) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    
    // Create spiral pattern with more curvature
    float spiral = sin(radius * 7.0 - angle * 3.0 - time * 0.5) * 0.5 + 0.5;
    
    // Add multiple arms
    float arms = sin(angle * 3.0 + time * 0.3) * 0.5 + 0.5;
    
    // Fade out with distance
    float fade = exp(-radius * 0.8);
    
    return spiral * arms * fade;
}

void main() {
    // Normalize coordinates
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 p = (uv - 0.5) * 2.0;
    p.x *= uSize.x / uSize.y; // Aspect ratio correction
    
    // Offset center slightly up
    p.y += 0.0;
    
    float radius = length(p);
    float angle = atan(p.y, p.x);
    
    // Rotating spiral arms
    float rotatedAngle = angle + uTime * 0.05;
    vec2 spiralP = vec2(cos(rotatedAngle), sin(rotatedAngle)) * radius;
    
    // Create spiral galaxy effect
    float spiralValue = spiral(spiralP, uTime);
    
    // Rotate stars around center
    float starRotation = uTime * 0.01;
    vec2 rotatedP = vec2(
        p.x * cos(starRotation) - p.y * sin(starRotation),
        p.x * sin(starRotation) + p.y * cos(starRotation)
    );
    
    // Add noise for stars
    float stars = noise(rotatedP * 80.0 + uTime * 0.1);
    stars = pow(stars, 200.0) * 2.5;
    
    // Center glow
    float glow = exp(-radius * 0.5) * 0.5;
    
    // Color gradient based on radius
    vec3 innerColor = vec3(0.412, 0.243, 0.659); // Bright blue-white
    vec3 middleColor = vec3(0.4, 0.6, 0.9); // Blue
    vec3 outerColor = vec3(0.063, 0, 0.369); // Dark blue
    vec3 bgColor = vec3(0.04, 0.12, 0.25); // Background
    
    // Mix colors based on radius with increased spiral intensity
    vec3 color = mix(bgColor, outerColor, spiralValue * 0.8);
    color = mix(color, middleColor, spiralValue * glow * 1.5);
    color = mix(color, innerColor, glow * 0.7);
    
    // Add stars
    color += vec3(stars);
    
    fragColor = vec4(color, 1.0);
}
