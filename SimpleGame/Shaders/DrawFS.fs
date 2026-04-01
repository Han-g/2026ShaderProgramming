#version 330

layout(location=0) out vec4 FragColor;

const float c_PI = 3.141592;
const vec2 c_G = vec2(0, -9.8);

in vec2 v_Tex;

uniform float u_Time;

void Simple()
{
	if (v_Tex.x < 0.5) {
		FragColor = vec4(0);
	}
	else {
		FragColor = vec4(1);
	}

	//FragColor = vec4(v_Tex, 0, 1);
	//FragColor = vec4(sin(v_Tex.x * 10 * 3.141592));
}

void Line()
{
	float period = v_Tex.x * 2 * c_PI * 5;
	float value = pow(abs(sin(period)), 16);
	
	FragColor = vec4(value);
}

void Row()
{
	float periodX = v_Tex.x * 2 * c_PI * 5;
	float periodY = v_Tex.y * 2 * c_PI * 5;
	float valueX = pow(abs(cos(periodX)), 16);
	float valueY = pow(abs(cos(periodY)), 16);
	
	FragColor = vec4(max(valueX, valueY));
}

void Sharp()
{
	float trans = c_PI / 2;
	float periodX = (v_Tex.x * 2 * c_PI - trans) * 5;
	float periodY = (v_Tex.y * 2 * c_PI - trans) * 5;
	float valueX = pow(abs(sin(periodX - periodY)), 16);
	float valueY = pow(abs(sin(periodY - (1 - periodX))), 16);
	
	FragColor = vec4(max(valueX, valueY));
}

void Circle()
{
	vec2 center = vec2(0.5, 0.5);
	vec2 currPos = v_Tex;
	float dist = distance(center, currPos);
	float width = 0.01;
	float raidus = 0.5;

	if(dist < raidus && dist > raidus - width) 
	{
		FragColor = vec4(1);
	}
	else
	{
		FragColor = vec4(0);
	}
	

	// length used
	//if(length(v_Tex - 0.5) < 0.5) 
	//{
	//	FragColor = vec4(1);
	//}
	//else
	//{
	//	FragColor = vec4(0);
	//}

	//FragColor = vec4(dist);
}

void Circles()
{
	vec2 center = vec2(0.5, 0.5);
	vec2 currPos = v_Tex;
	float count = 5;

	float dist = distance(center, currPos);
	
	float gray = pow(abs(sin(dist * 2 * c_PI * count + u_Time)), 32);

	FragColor = vec4(gray);
}

void main()
{
	Circles();
}