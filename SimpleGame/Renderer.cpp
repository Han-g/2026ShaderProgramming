#include "stdafx.h"
#include "Renderer.h"

#include <ctime>

Renderer::Renderer(int windowSizeX, int windowSizeY)
{
	Initialize(windowSizeX, windowSizeY);
}


Renderer::~Renderer()
{
}

void Renderer::Initialize(int windowSizeX, int windowSizeY)
{
	//Set window size
	m_WindowSizeX = windowSizeX;
	m_WindowSizeY = windowSizeY;

	//Load shaders
	m_SolidRectShader = CompileShaders("./Shaders/SolidRect.vs", "./Shaders/SolidRect.fs");
	m_TriangleShader = CompileShaders("./Shaders/SolidTri.vs", "./Shaders/SolidTri.fs");
	m_MyShader = CompileShaders("./Shaders/DrawFS.vs", "./Shaders/DrawFS.fs");
	
	//Create VBOs
	CreateVertexBufferObjects();

	//GenParticles(1000);

	if (m_SolidRectShader > 0 && m_VBORect > 0)
	{
		m_Initialized = true;
	}
}

bool Renderer::IsInitialized()
{
	return m_Initialized;
}

void Renderer::CreateVertexBufferObjects()
{
	float rect[]
		=
	{
		-1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f, -1.f / m_WindowSizeX, 1.f / m_WindowSizeY, 0.f, 1.f / m_WindowSizeX, 1.f / m_WindowSizeY, 0.f, //Triangle1
		-1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f,  1.f / m_WindowSizeX, 1.f / m_WindowSizeY, 0.f, 1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f, //Triangle2
	};

	glGenBuffers(1, &m_VBORect);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBORect);
	glBufferData(GL_ARRAY_BUFFER, sizeof(rect), rect, GL_STATIC_DRAW);

	/*float centerX = 0, centerY = 1;
	float vx = 1, vy = 1;
	float size = 0.1;
	float mass = 1;
	float rV = 0;

	float triangle[]
		=
	{
		centerX - size / 2, centerY - size / 2, 0, mass, vx, vy, rV,
		centerX + size / 2, centerY - size / 2 ,0, mass, vx, vy, rV,
		centerX + size / 2, centerY + size / 2, 0, mass, vx, vy, rV,

		centerX - size / 2, centerY - size / 2, 0, mass, vx, vy, rV,
		centerX + size / 2, centerY + size / 2, 0, mass, vx, vy, rV,
		centerX - size / 2, centerY + size / 2, 0, mass, vx, vy, rV
	};

	glGenBuffers(1, &m_TriVBO);
	glBindBuffer(GL_ARRAY_BUFFER, m_TriVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(triangle), triangle, GL_STATIC_DRAW);*/
	
	
	// x, y, z, tx, ty
	float rectFS[]
		=
	{
		-1,	-1, 0, 0, 1,
		 1,	 1, 0, 1, 0,
		-1,	 1, 0, 0, 0,

		-1, -1, 0, 0, 1,
		 1, -1, 0, 1, 1,
		 1,  1, 0, 1, 0,
	};

	glGenBuffers(1, &m_MyVBO);
	glBindBuffer(GL_ARRAY_BUFFER, m_MyVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(rectFS), rectFS, GL_STATIC_DRAW);
}

void Renderer::GenParticles(int PartNum)
{
	// 랜덤 시드 초기화 (프로그램 실행 시 한 번만 호출되는 곳에 넣어도 무방)
	srand((unsigned int)time(NULL));

	std::vector<float> particleData;
	float size = 0.02f; // 개별 파티클의 크기

	for (int i = 0; i < PartNum; ++i)
	{
		// 1. 랜덤 위치 생성 (-1.0 ~ 1.0 사이의 NDC 좌표)
		float centerX = 0; // ((float)(rand() % 2000) / 1000.0f) - 1.0f;
		float centerY = 0; // ((float)(rand() % 2000) / 1000.0f) - 1.0f;

		// 2. 랜덤 초기 속도 생성 (-2.0 ~ 2.0 사이)
		float vx = 0; // ((float)(rand() % 4000) / 1000.0f) - 0.5f;
		float vy = 0; // ((float)(rand() % 1000) / 1000.0f);

		float mass = 1.0f; // 질량 (필요에 따라 랜덤화 가능)

		float RV = ((float)(rand() % 2000) / 1000.0f) - 1.0f;	// -1 ~ 1
		float RV1 = ((float)(rand() % 2000) / 1000.0f) - 1.0f; //((float)(rand() % 1000) / 1000.0f);			// 0 ~ 1
		float RV2 = ((float)(rand() % 2000) / 1000.0f) - 1.0f; //((float)(rand() % 1000) / 1000.0f) - 1.0f;	// -1 ~ 0


		// 데이터 구조: x, y, z, mass, velocity_x, velocity_y, RandomValue0, RandomValue1

		// 첫 번째 삼각형
		particleData.push_back(centerX - size / 2); particleData.push_back(centerY - size / 2); particleData.push_back(0.0f);
		particleData.push_back(mass); particleData.push_back(vx); particleData.push_back(vy); 
		particleData.push_back(RV); particleData.push_back(RV1); particleData.push_back(RV2);

		particleData.push_back(centerX + size / 2); particleData.push_back(centerY - size / 2); particleData.push_back(0.0f);
		particleData.push_back(mass); particleData.push_back(vx); particleData.push_back(vy); 
		particleData.push_back(RV); particleData.push_back(RV1); particleData.push_back(RV2);

		particleData.push_back(centerX + size / 2); particleData.push_back(centerY + size / 2); particleData.push_back(0.0f);
		particleData.push_back(mass); particleData.push_back(vx); particleData.push_back(vy); 
		particleData.push_back(RV); particleData.push_back(RV1); particleData.push_back(RV2);

		// 두 번째 삼각형
		particleData.push_back(centerX - size / 2); particleData.push_back(centerY - size / 2); particleData.push_back(0.0f);
		particleData.push_back(mass); particleData.push_back(vx); particleData.push_back(vy); 
		particleData.push_back(RV); particleData.push_back(RV1); particleData.push_back(RV2);

		particleData.push_back(centerX + size / 2); particleData.push_back(centerY + size / 2); particleData.push_back(0.0f);
		particleData.push_back(mass); particleData.push_back(vx); particleData.push_back(vy); 
		particleData.push_back(RV); particleData.push_back(RV1); particleData.push_back(RV2);

		particleData.push_back(centerX - size / 2); particleData.push_back(centerY + size / 2); particleData.push_back(0.0f);
		particleData.push_back(mass); particleData.push_back(vx); particleData.push_back(vy); 
		particleData.push_back(RV); particleData.push_back(RV1); particleData.push_back(RV2);
	}

	// 전체 정점 개수 갱신 (파티클 1개당 정점 6개)
	m_VertexCount = PartNum * 8;

	// 4. VBO 생성 및 데이터 업로드
	if (m_TriVBO == 0)
	{
		glGenBuffers(1, &m_TriVBO);
	}
	glBindBuffer(GL_ARRAY_BUFFER, m_TriVBO);
	glBufferData(GL_ARRAY_BUFFER, particleData.size() * sizeof(float), particleData.data(), GL_STATIC_DRAW);
}

void Renderer::AddShader(GLuint ShaderProgram, const char* pShaderText, GLenum ShaderType)
{
	//쉐이더 오브젝트 생성
	GLuint ShaderObj = glCreateShader(ShaderType);

	if (ShaderObj == 0) {
		fprintf(stderr, "Error creating shader type %d\n", ShaderType);
	}

	const GLchar* p[1];
	p[0] = pShaderText;
	GLint Lengths[1];
	Lengths[0] = strlen(pShaderText);
	//쉐이더 코드를 쉐이더 오브젝트에 할당
	glShaderSource(ShaderObj, 1, p, Lengths);

	//할당된 쉐이더 코드를 컴파일
	glCompileShader(ShaderObj);

	GLint success;
	// ShaderObj 가 성공적으로 컴파일 되었는지 확인
	glGetShaderiv(ShaderObj, GL_COMPILE_STATUS, &success);
	if (!success) {
		GLchar InfoLog[1024];

		//OpenGL 의 shader log 데이터를 가져옴
		glGetShaderInfoLog(ShaderObj, 1024, NULL, InfoLog);
		fprintf(stderr, "Error compiling shader type %d: '%s'\n", ShaderType, InfoLog);
		printf("%s \n", pShaderText);
	}

	// ShaderProgram 에 attach!!
	glAttachShader(ShaderProgram, ShaderObj);
}

bool Renderer::ReadFile(char* filename, std::string *target)
{
	std::ifstream file(filename);
	if (file.fail())
	{
		std::cout << filename << " file loading failed.. \n";
		file.close();
		return false;
	}
	std::string line;
	while (getline(file, line)) {
		target->append(line.c_str());
		target->append("\n");
	}
	return true;
}

GLuint Renderer::CompileShaders(char* filenameVS, char* filenameFS)
{
	GLuint ShaderProgram = glCreateProgram(); //빈 쉐이더 프로그램 생성

	if (ShaderProgram == 0) { //쉐이더 프로그램이 만들어졌는지 확인
		fprintf(stderr, "Error creating shader program\n");
	}

	std::string vs, fs;

	//shader.vs 가 vs 안으로 로딩됨
	if (!ReadFile(filenameVS, &vs)) {
		printf("Error compiling vertex shader\n");
		return -1;
	};

	//shader.fs 가 fs 안으로 로딩됨
	if (!ReadFile(filenameFS, &fs)) {
		printf("Error compiling fragment shader\n");
		return -1;
	};

	// ShaderProgram 에 vs.c_str() 버텍스 쉐이더를 컴파일한 결과를 attach함
	AddShader(ShaderProgram, vs.c_str(), GL_VERTEX_SHADER);

	// ShaderProgram 에 fs.c_str() 프레그먼트 쉐이더를 컴파일한 결과를 attach함
	AddShader(ShaderProgram, fs.c_str(), GL_FRAGMENT_SHADER);

	GLint Success = 0;
	GLchar ErrorLog[1024] = { 0 };

	//Attach 완료된 shaderProgram 을 링킹함
	glLinkProgram(ShaderProgram);

	//링크가 성공했는지 확인
	glGetProgramiv(ShaderProgram, GL_LINK_STATUS, &Success);

	if (Success == 0) {
		// shader program 로그를 받아옴
		glGetProgramInfoLog(ShaderProgram, sizeof(ErrorLog), NULL, ErrorLog);
		std::cout << filenameVS << ", " << filenameFS << " Error linking shader program\n" << ErrorLog;
		return -1;
	}

	glValidateProgram(ShaderProgram);
	glGetProgramiv(ShaderProgram, GL_VALIDATE_STATUS, &Success);
	if (!Success) {
		glGetProgramInfoLog(ShaderProgram, sizeof(ErrorLog), NULL, ErrorLog);
		std::cout << filenameVS << ", " << filenameFS << " Error validating shader program\n" << ErrorLog;
		return -1;
	}

	glUseProgram(ShaderProgram);
	std::cout << filenameVS << ", " << filenameFS << " Shader compiling is done." << std::endl;

	return ShaderProgram;
}

void Renderer::DrawSolidRect(float x, float y, float z, float size, float r, float g, float b, float a)
{
	float newX, newY;

	GetGLPosition(x, y, &newX, &newY);

	//Program select
	glUseProgram(m_SolidRectShader);

	glUniform4f(glGetUniformLocation(m_SolidRectShader, "u_Trans"), newX, newY, 0, size);
	glUniform4f(glGetUniformLocation(m_SolidRectShader, "u_Color"), r, g, b, a);

	int attribPosition = glGetAttribLocation(m_SolidRectShader, "a_Position");
	glEnableVertexAttribArray(attribPosition);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBORect);
	glVertexAttribPointer(attribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, 0);

	glDrawArrays(GL_TRIANGLES, 0, 6);

	glDisableVertexAttribArray(attribPosition);

	glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

float gTime = 0;
void Renderer::DrawTriangle()
{
	gTime += 0.0001;
	//Program select
	glUseProgram(m_TriangleShader);

	int uTime = glGetUniformLocation(m_TriangleShader, "u_Time");
	glUniform1f(uTime, 0 + gTime);

	int attribPosition	= glGetAttribLocation(m_TriangleShader, "a_Position");
	int attribMass		= glGetAttribLocation(m_TriangleShader, "a_Mass");
	int attribVel		= glGetAttribLocation(m_TriangleShader, "a_Vel");
	int attribRandom	= glGetAttribLocation(m_TriangleShader, "a_RV");
	int attribRandom1	= glGetAttribLocation(m_TriangleShader, "a_RV1");
	int attribRandom2	= glGetAttribLocation(m_TriangleShader, "a_RV2");

	glEnableVertexAttribArray(attribPosition);
	glEnableVertexAttribArray(attribMass);
	glEnableVertexAttribArray(attribVel);
	glEnableVertexAttribArray(attribRandom);
	glEnableVertexAttribArray(attribRandom1);
	glEnableVertexAttribArray(attribRandom2);

	int AttribPointerSize = sizeof(float) * 9;

	glBindBuffer(GL_ARRAY_BUFFER, m_TriVBO);
	glVertexAttribPointer(attribPosition, 3, GL_FLOAT, GL_FALSE, AttribPointerSize, 0);
	glVertexAttribPointer(attribMass	, 1, GL_FLOAT, GL_FALSE, AttribPointerSize, (GLvoid*)(sizeof(float) * 3));
	glVertexAttribPointer(attribVel		, 2, GL_FLOAT, GL_FALSE, AttribPointerSize, (GLvoid*)(sizeof(float) * 4));
	glVertexAttribPointer(attribRandom	, 1, GL_FLOAT, GL_FALSE, AttribPointerSize, (GLvoid*)(sizeof(float) * 6));
	glVertexAttribPointer(attribRandom1	, 1, GL_FLOAT, GL_FALSE, AttribPointerSize, (GLvoid*)(sizeof(float) * 7));
	glVertexAttribPointer(attribRandom2 , 1, GL_FLOAT, GL_FALSE, AttribPointerSize, (GLvoid*)(sizeof(float) * 8));

	glDrawArrays(GL_TRIANGLES, 0, m_VertexCount); // Draw Call
}

void Renderer::DrawFS()
{
	gTime += 0.001;
	//Program select
	GLuint shader = m_MyShader;
	glUseProgram(shader);

	int uTime = glGetUniformLocation(m_TriangleShader, "u_Time");
	glUniform1f(uTime, gTime);

	int attribPosition = glGetAttribLocation(shader, "a_Position");
	int attribTexture = glGetAttribLocation(shader, "a_Texture");

	glEnableVertexAttribArray(attribPosition);
	glEnableVertexAttribArray(attribTexture);

	int AttribPointerSize = sizeof(float) * 5;

	glBindBuffer(GL_ARRAY_BUFFER, m_MyVBO);
	glVertexAttribPointer(attribPosition, 3, GL_FLOAT, GL_FALSE, AttribPointerSize, 0);
	glVertexAttribPointer(attribTexture, 2, GL_FLOAT, GL_FALSE, AttribPointerSize, (GLvoid*)(sizeof(float) * 3));

	glDrawArrays(GL_TRIANGLES, 0, 6); // Draw Call
}

void Renderer::GetGLPosition(float x, float y, float *newX, float *newY)
{
	*newX = x * 2.f / m_WindowSizeX;
	*newY = y * 2.f / m_WindowSizeY;
}