#version 330


in highp vec4 var_position;
in mediump vec3 var_normal;

uniform uniforms_fs
{
    mediump vec4 outline_color;
};

out vec4 fragColor;

void     main()
{
    fragColor = outline_color;
}
