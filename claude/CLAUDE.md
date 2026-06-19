🛠 Claude CLI 개발 및 업무 자동화 통합 지침
0. 그때 그때 상황에 맞는 적절한 plugin, skill, agent를 활용합니다.

1. 개발 원칙 및 커뮤니케이션
코드 품질: 개발 단계에서는 코드가 스스로 설명되도록 작성하며 주석을 최소화합니다. 기능 완료 후 API 문서나 복잡한 로직에 대해서만 상세 주석을 추가합니다.

성능 및 구조: 중복 코드는 함수나 클래스로 분리하여 유지보수성을 높입니다. Python 반복문은 NumPy 배열을 사용한 고성능 벡터화 연산으로 대체하여 속도를 향상시킵니다.
특정 명사와 대명사를 제외하고는 모든 설명을 한국어로 진행합니다.

사전 확정: 프로그래밍 시작 전 반드시 사용자에게 **분야(Domain)**와 **핵심 기능(Core Functions)**을 질문합니다. 이후 상세 명세와 제약 조건이 담긴 최적화된 프롬프트를 생성하여 방향성을 확정합니다.

2. 변경 관리 및 안전 프로토콜
영향도 분석: 코드 수정 전 반드시 전수 검사와 영향도 분석을 수행합니다.

백업 전략: 수정 직전 타임스탬프 기반 백업(filename_20260406.bak 등)을 생성한 후, 단계적으로 수정하고 검증합니다.

수정 명시: 파일 수정 시 어느 파일의 어느 부분이 변경되는지 명확히 밝힙니다. 양이 많을 경우 순차적으로 진행함을 알리고 대화당 한 단계씩 처리합니다.

3. MCP 기반 자동 업무 프로세스
모든 작업 요청 시 다음 단계를 사용자 추가 명령 없이도 순차적으로 자동 수행합니다:

단계적 사고 (Sequential Thinking): mcp_sequential-thinking을 호출하여 구현 단계, 알고리즘 설계 및 예외 상황을 먼저 논리적으로 정리합니다.

파일 작업 (Filesystem): 설계된 내용을 바탕으로 mcp_server-filesystem을 사용해 코드를 생성하거나 수정합니다.
자동 코드 리뷰 (Gemini CLI): 파일 수정 직후 아래 명령어를 자동 실행하여 외부 리뷰를 수행합니다.

gemini -p "다음 파일의 변경 사항을 리뷰하고, 논리적 오류나 개선점을 피드백해줘: [파일명]"

Gemini의 리뷰 결과에 수정 권고가 있다면 즉시 코드를 재수정합니다.

최종 완료 후 mcp_github를 통해 Push하고, mcp_notion을 사용하여 작업 내용과 결과(예: 새로운 Loss 함수 설계 내용 등)를 요약 기록합니다.

##Rules
- skill, plugin, agent를 사용했다면, 어떤거를 뭐 할때 썼는지 대화 가장 마지막에 알려줍니다.
- Using 3 sub agents
- Use ultrathink
- always before making any change, search on the web for the newest documentation
- Only implement if you are 100% sure it will work
