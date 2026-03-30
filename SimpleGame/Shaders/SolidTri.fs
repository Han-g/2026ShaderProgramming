#version 330

layout(location=0) out vec4 FragColor;

in float v_Gray;

void main()
{
	// 터보 불꽃의 온도별 색상 정의 (RGB)
    vec3 hotCoreColor = vec3(0.8, 0.9, 1.0); // 1.0에 가까울 때: 백색/밝은 하늘색 (가장 뜨거운 중심)
    vec3 midFlameColor = vec3(0.1, 0.3, 1.0); // 중간 온도: 짙은 파란색
    vec3 outFlameColor = vec3(0.5, 0.0, 0.8); // 0.0에 가까울 때: 보라색/붉은색 계열로 식으며 소멸

    vec3 finalColor;

    // v_Gray 값에 따라 색상을 자연스럽게 섞어줍니다 (Gradient)
    if (v_Gray > 0.5) 
    {
        // v_Gray가 0.5 ~ 1.0 일 때 (하단~중단)
        // 0.0 ~ 1.0 비율로 맞추기 위해 (v_Gray - 0.5) * 2.0 을 적용
        float factor = (v_Gray - 0.5) * 2.0;
        finalColor = mix(midFlameColor, hotCoreColor, factor);
    }
    else 
    {
        // v_Gray가 0.0 ~ 0.5 일 때 (중단~상단 끝)
        float factor = v_Gray * 2.0;
        finalColor = mix(outFlameColor, midFlameColor, factor);
    }

    // C++쪽에서 알파 블렌딩(GL_BLEND) 옵션이 켜져 있지 않을 경우를 대비해, 
    // v_Gray가 0에 가까워질수록 색상 자체를 검은색으로 페이드아웃 시킵니다.
    finalColor = finalColor * v_Gray;

    // 최종 색상 출력 (알파값도 v_Gray로 주어 서서히 투명해지도록 설정)
    FragColor = vec4(1); // = vec4(finalColor, v_Gray);
}
