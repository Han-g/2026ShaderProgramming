#version 330

layout(location=0) out vec4 FragColor;

in float v_Gray;

void main()
{
	FragColor = vec4(v_Gray);
}
