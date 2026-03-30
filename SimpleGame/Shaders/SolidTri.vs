#version 330

uniform float u_Time;


in vec3 a_Position;
in float a_Mass;
in vec2 a_Vel;
in float a_RV;
in float a_RV1;
in float a_RV2;

out float v_Gray;


const float c_PI = 3.141592;
const vec2 c_G = vec2(0, -9.8);

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


void Falling()
{
	float t = mod(u_Time, 1.0);
	vec4 newPos;

	float initPosX = a_Position.x + sin(a_RV * 2 * c_PI);
	float initPosY = a_Position.y + cos(a_RV * 2 * c_PI);

	newPos.x = initPosX + (a_Vel.x * t) + (c_G.x * t * t * 0.5);
	newPos.y = initPosY + (a_Vel.y * t) + (c_G.y * t * t * 0.5);
	newPos.z = 0;
	newPos.w = 1;

	gl_Position = newPos;
}

float pseudoRandom(float p) {
    // A high-amplitude sin function with fract() to produce a [0, 1) range
    return fract(sin(p) * 43758.5453123);
}

void DiffTimeFalling()
{
	//emitTime
	float newTime = u_Time - a_RV1;

	if (newTime > 0) {
		float t = mod(newTime, 1.0);
		vec4 newPos;

		float initPosX = a_Position.x + sin(a_RV * 2 * c_PI);
		float initPosY = a_Position.y + cos(a_RV * 2 * c_PI);

		newPos.x = initPosX + (a_Vel.x * t) + (c_G.x * t * t * 0.5);
		newPos.y = initPosY + (a_Vel.y * t) + (c_G.y * t * t * 0.5);
		newPos.z = 0;
		newPos.w = 1;

		gl_Position = newPos;
	}

	else {
		gl_Position = vec4(2, 2, 2, 2);
	}
}

void DiffSizeFalling()
{
	//emitTime
	float newTime = u_Time - a_RV1;

	if (newTime > 0) {
		float t = mod(newTime, 1.0);
		vec4 newPos;

		float scale = pseudoRandom(a_RV);
		float initPosX = a_Position.x * scale + sin(a_RV * 2 * c_PI);
		float initPosY = a_Position.y * scale + cos(a_RV * 2 * c_PI);

		newPos.x = initPosX + (a_Vel.x * t) + (c_G.x * t * t * 0.5);
		newPos.y = initPosY + (a_Vel.y * t) + (c_G.y * t * t * 0.5);
		newPos.z = 0;
		newPos.w = 1;

		gl_Position = newPos;
	}

	else {
		gl_Position = vec4(2, 2, 2, 2);
	}
}

void AImadeParticle()
{
	// 1. 개별 파티클의 생명 주기(LifeTime)와 진행률(t) 설정
    // a_RV1을 활용해 파티클마다 생성되는 타이밍을 엇갈리게 만듭니다.
    // 3.0을 주기로 하여 0.0 ~ 1.0 사이의 진행률(t)을 구합니다.
    float lifeTime = mod(u_Time + a_RV1 * 5.0, 3.0);
    float t = lifeTime / 3.0; 
    
    // 2. 회전 각도(Angle) 계산
    // a_RV를 사용하여 파티클마다 고유한 시작 각도(360도 내의 특정 위치)를 부여합니다.
    // t에 15.0(회전 속도 배율)을 곱해 시간이 지날수록 중심을 기준으로 소용돌이치게 합니다.
    float angle = (a_RV * 2.0 * c_PI) + (t * 15.0);
    
    // 3. 퍼져나가는 반경(Radius) 계산
    // 시간이 지날수록(t) 반경이 커지며, a_RV1을 섞어 파티클마다 퍼져나가는 최대 반경을 다르게 만듭니다.
    float radius = t * (1.5 + sin(a_RV1));
    
    // 4. 파티클 크기(Scale) 제어
    // sin(t * c_PI)를 사용하여 파티클이 생성될 때 작았다가, 중간에 커지고, 사라질 때 다시 작아지는 효과를 줍니다.
    float scale = sin(t * c_PI) * 0.8;
    
    vec4 newPos;
    // 삼각함수를 이용한 원운동 궤적 좌표 산출
    float moveX = radius * cos(angle);
    float moveY = radius * sin(angle);
    
    // 원래 정점 위치에 스케일을 곱해 크기를 조정하고, 이동할 좌표를 더합니다.
    newPos.x = (a_Position.x * scale) + moveX;
    newPos.y = (a_Position.y * scale) + moveY;
    newPos.z = 0.0;
    newPos.w = 1.0;
    
    gl_Position = newPos;
}

void waterfall()
{
    // 전체 생명 주기(1.2초)와 개별 파티클의 진행 시간(t)
    float lifeTime = 1.2;
    float t = mod(u_Time + (a_RV1 * 5.0), lifeTime);

    // 물리 상수 및 기준점 설정
    float t_hit = 0.45;     // 물줄기가 바닥에 닿는 시점 (0.45초)
    float startY = 1.0;     // 물이 쏟아지는 시작 높이
    float drop_vY = -2.0;   // 초기 하강 속도 (아래로 쏘아줌)

    // t_hit 시점의 Y좌표를 계산하여 바닥(Floor)의 높이를 정확히 도출
    // 이를 통해 낙하 상태에서 튕김 상태로 넘어갈 때 위치가 끊기지(순간이동) 않습니다.
    float floorY = startY + (drop_vY * t_hit) + (c_G.y * t_hit * t_hit * 0.5);

    // 중앙에서 약간의 오차(-0.1 ~ 0.1)만 가지고 떨어지도록 시작 X 좌표 설정
    float startX = (a_RV - 0.5) * 0.2;

    vec4 newPos;
    newPos.z = a_Position.z;
    newPos.w = 1.0;

    // 시간에 따른 물리 상태 분기
    if (t < t_hit)
    {
        // ==========================================
        // [1단계: 낙하하는 물줄기]
        // ==========================================
        // 중력 가속도를 받으며 떨어지므로, 길이는 늘어나고 폭은 좁아지는 왜곡 효과 적용
        float stretchY = 1.0 + (t * 4.0);
        float shrinkX = max(0.2, 1.0 - (t * 1.5));

        newPos.x = (a_Position.x * shrinkX) + startX;
        newPos.y = (a_Position.y * stretchY) + startY + (drop_vY * t) + (c_G.y * t * t * 0.5);
    }
    else
    {
        // ==========================================
        // [2단계: 바닥에 닿고 튀어 오르는 물방울]
        // ==========================================
        float bounce_t = t - t_hit; // 충돌 직후부터 새로 측정되는 로컬 시간

        // 충돌 시 사방으로 퍼지는 폭발적인 반발력 (난수 a_RV, a_RV1 활용)
        // X축: -3.0 ~ 3.0 범위로 무작위로 흩어짐
        // Y축: 3.0 ~ 6.0 범위의 초기 속도로 위로 강하게 튀어 오름
        float bounceVx = (a_RV - 0.5) * 6.0;
        float bounceVy = 3.0 + (a_RV1 * 3.0);

        // 물방울 형태로 변환 (스케일을 작게 줄이고, 수명이 다할수록 0에 가깝게 소멸)
        float scale = 0.4 * (1.0 - (bounce_t / (lifeTime - t_hit)));

        // 충돌 지점(startX, floorY)을 새로운 원점으로 하여 2차 포물선 운동 시작
        newPos.x = (a_Position.x * scale) + startX + (bounceVx * bounce_t);
        newPos.y = (a_Position.y * scale) + floorY + (bounceVy * bounce_t) + (c_G.y * bounce_t * bounce_t * 0.5);
    }

    gl_Position = newPos;
}

void m()
{
    float newTime = u_Time - a_RV1 * 3;
	
    if (newTime > 0)
	{
		float lifeTime = (a_RV2 + 0.5) * 0.2;
		float t = mod(newTime, lifeTime);
		float scale = pseudoRandom(a_RV1) * (lifeTime - t) / lifeTime;
		vec4 newPos;

		float initPosX = a_Position.x * scale + sin(a_RV * 2 * c_PI);
		float initPosY = a_Position.y * scale + cos(a_RV * 2 * c_PI);

		newPos.x = initPosX + (a_Vel.x * t) + (c_G.x * t * t * 0.5);
		newPos.y = initPosY + (a_Vel.y * t) + (c_G.y * t * t * 0.5);
		newPos.z = 0;
		newPos.w = 1;

		gl_Position = newPos;
	}
    else 
    {
        gl_Position = vec4(2.0, 2.0, 2.0, 2.0);
    }
}

void Thrust()
{
    // example 3

    float newTime = u_Time - a_RV1;
    if(newTime > 0)
    {
        float t = mod(newTime, 1.0);
        float scale = 0.5 + (t * 0.5);
        float ampScale = 0.5 * t;
        float amp = a_RV * ampScale;
        float period = (a_RV2);
        vec4 newPosition;

        newPosition.x = ((a_Position.x * scale) - 1) + (t * 2);
        newPosition.y = (a_Position.y * scale) + (sin(t * period * c_PI) * amp);
        newPosition.z = a_Position.z;
        newPosition.w = 1;

        gl_Position = newPosition;

        v_Gray = 1 - t;
    }
    else
    {
        gl_Position = vec4(2,2,2,2);
        v_Gray = 0;
    }

    // example 1
    
    //float amp = a_RV;
    //float t = mod(u_Time, 1.0);
    //float startTime = a_RV1 + t;
	//vec4 newPosition;

	//newPosition.x = (a_Position.x - 1) + (startTime * 2);
	//newPosition.y = a_Position.y + sin(startTime * 2 * 3.141592) * amp;
	//newPosition.z = a_Position.z;
	//newPosition.w = 1.0;

	//gl_Position = newPosition;

    // example 2

    //float newTime = u_Time - a_RV1;
    //if(newTime > 0)
    //{
    //    float t = mod(newTime, 1.0);
    //    float ampScale = 0.5 * t;
    //    float amp = a_RV * ampScale;
    //    float period = (a_RV2);
    //    vec4 newPosition;

    //    newPosition.x = (a_Position.x - 1) + (t * 2);
    //    newPosition.y = a_Position.y + (sin(t * period * c_PI) * amp);
    //    newPosition.z = a_Position.z;
    //    newPosition.w = 1;

    //    gl_Position = newPosition;
    //}
}

void AIFrame()
{
    float newTime = u_Time - a_RV1;
    if(newTime > 0.0)
    {
        // 1. 생명 주기: 터보 라이터의 가스 분출 속도처럼 매우 짧게 설정 (0.2~0.3초)
        float lifeTime = 0.25; 
        float t = mod(newTime, lifeTime) / lifeTime; 

        // 2. 스케일: 밑동은 유지되다가 끝부분에서 급격히 날카로워지도록 t^2 사용
        float scale = 0.6 * (1.0 - (t * t)); 

        // 3. 수직 이동: Y축으로 매우 빠르게 쏘아올림
        float startY = -0.8;
        float speed = 5.0; // 분출 속도
        float moveY = startY + (t * speed);

        // 4. 터보 진동(Jittering): 크고 느린 일렁임(Sway)이 아닌, 미세하고 빠른 떨림
        // 주파수를 100~200 수준으로 올려서 눈에 보일 듯 말 듯 빠르게 떨게 만듭니다.
        float jitterFreq = 150.0 + (a_RV2 * 50.0); 
        float jitterAmp = 0.03 * t; // 진폭은 매우 좁게 제한
        
        // X축 생성 위치도 매우 좁은 범위(0.05) 내로 제한하여 곧게 뻗게 함
        float startX = (a_RV - 0.5) * 0.05; 
        float moveX = startX + (sin(newTime * jitterFreq) * jitterAmp);

        vec4 newPosition;
        newPosition.x = (a_Position.x * scale) + moveX;
        newPosition.y = (a_Position.y * scale) + moveY;
        newPosition.z = a_Position.z;
        newPosition.w = 1.0;

        gl_Position = newPosition;

        // 5. v_Gray 설정 (프래그먼트 셰이더로 전달)
        // 아주 빠른 깜빡임을 섞어서 불꽃의 코어 에너지를 표현
        float flicker = 0.85 + 0.15 * sin(newTime * 300.0);
        v_Gray = (1.0 - t) * flicker;
    }
    else
    {
        gl_Position = vec4(2.0, 2.0, 2.0, 2.0);
        v_Gray = 0.0;
    }
}

void main()
{
	AIFrame();
	//Thrust();
}
