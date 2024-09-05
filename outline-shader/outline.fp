#version 330

uniform uniforms_fs { mediump vec4 outline_color; };

out vec4 fragColor;

void main() { fragColor = outline_color; }
