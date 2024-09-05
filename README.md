# Defold 3D Outline Shader

![Outline](/.github/hull.png?raw=true)

![Outline](/.github/stencil.png?raw=true)

Simple outline shader for 3D models using STENCIL and INVERTED HULL techniques.

The outline vertex shader uses 'normal' to move the vertices along their [normal vector](https://github.com/selimanac/defold-3D-outline-shader/blob/0ddf4f56a6edabda76f0257634acf72f7e8b4d81/outline-shader/outline.vp#L22). For objects with sharper corners, such as cubes, you may notice visible gaps in the outline. Any model with sharp angles will display these kinds of artifacts.

If you want better results, including sharper corners, consider using vertex color attributes. To use vertex colors, you can comment out [this line](https://github.com/selimanac/defold-3D-outline-shader/blob/0ddf4f56a6edabda76f0257634acf72f7e8b4d81/outline-shader/outline.vp#L22) and uncomment [that one](https://github.com/selimanac/defold-3D-outline-shader/blob/0ddf4f56a6edabda76f0257634acf72f7e8b4d81/outline-shader/outline.vp#L23).

More info can be found here:  https://ameye.dev/notes/rendering-outlines/

There are better methods available if you're interested: https://roystan.net/articles/outline-shader/

Additionally, there's a simple Lua helper module for easy integration with your render script.



