#version 330

in vec3 a_Position;
in vec2 a_Texture;

out vec2 v_Tex;

void main()
{
	vec4 newPosition;
	newPosition = vec4(a_Position, 1);

	v_Tex = a_Texture;

	gl_Position = newPosition;
}
