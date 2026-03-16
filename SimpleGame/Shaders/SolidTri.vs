#version 330

uniform float u_Time;
in vec3 a_Position;

void Basic()
{
	float t = mod(u_Time, 1.0);
	vec4 newPosition;
	newPosition.x = a_Position.x + t;
	newPosition.y = a_Position.y;
	newPosition.z = a_Position.z;
	newPosition.w = 1.0;
	gl_Position = newPosition;
}

void Sin1()
{
	float t = mod(u_Time, 1.0);
	vec4 newPosition;
	newPosition.x = a_Position.x + t;
	newPosition.y = a_Position.y + sin(t*2*3.141592);
	newPosition.z = a_Position.z;
	newPosition.w = 1.0;
	gl_Position = newPosition;
}

void Sin2()
{
	float t = fract(u_Time * 1.0);
	float moveX = -1.0 + (t * 2.0);

	vec4 newPosition;
	newPosition.x = a_Position.x + moveX;
	newPosition.y = a_Position.y + sin(t*2*3.141592);
	newPosition.z = a_Position.z;
	newPosition.w = 1.0;

	gl_Position = newPosition;
}

void Sin3()
{
	float t = mod(u_Time, 2.0);

	vec4 newPosition;
	newPosition.x = a_Position.x - 1 + t;
	newPosition.y = a_Position.y + sin(t*2*3.141592);
	newPosition.z = a_Position.z;
	newPosition.w = 1.0;

	gl_Position = newPosition;
}

void Circle()
{
	float speed = 20.0;
	float theta = u_Time * speed; 
    float radius = 1;

	vec4 newPosition;
	newPosition.x = a_Position.x + radius * cos(theta);
    newPosition.y = a_Position.y + radius * sin(theta);
	newPosition.z = a_Position.z;
	newPosition.w = 1.0;

	gl_Position = newPosition;
}

void Tino()
{
    float speed = 5.0;
    float t = u_Time * speed;
    
    float base_x = 0.5 * cos(t) - 0.2 * sin(2.0 * t);
    float base_y = 0.6 * sin(t) + 0.1 * cos(2.0 * t);
    
    float tail_x = 0.1 * cos(3.0 * t);
    float tail_y = 0.05 * sin(3.0 * t);

    float moveX = base_x + tail_x;
    float moveY = base_y + tail_y;

    vec4 newPosition;
    newPosition.x = a_Position.x + moveX;
    newPosition.y = a_Position.y + moveY;
    newPosition.z = a_Position.z;
    newPosition.w = 1.0;

    gl_Position = newPosition;
}

void main()
{
	Tino();
}
