![20250616_011423 (1).jpg](attachment:f8d0f108-0278-4e60-8ef6-259138647d99:20250616_011423_(1).jpg)

## 📱 ReTap: 목표관리와 자기 피드백 Frontend

ReTap은 반복적인 목표 실천을 돕기 위한 **루틴 기반 자기 관리 앱**입니다.  
친구들과 매년 새해 계획을 편지로 나누던 경험에서 출발해,  
"적은 목표를 실제로 실천하고, 돌아볼 수 있는 구조가 필요하다"는 문제의식으로 기획되었습니다.

**만든 것**  
- OAuth 2.0 + JWT + Refresh Token 구조를 포함한 전체 인증 시스템 설계 및 구현  
- 목표 작성 → 알림 수신 → 피드백 기록까지의 핵심 루틴 기능을 모바일 앱과 백엔드 전반에서 연결  
- 무중단 배포 파이프라인 구축 및 플레이스토어 앱 심사 통과까지 모든 릴리스 과정을 경험

---

## 🧠 출시노트

ReTap: 목표 관리와 자기 피드백

목표를 작성하고, 알림받고, 스스로 평가하세요. 당신만의 성장 루틴을 만드세요.

ReTap은 당신의 목표를 구체적으로 기록하고, 정해진 알림일자에 푸시 알림으로 다시 상기시켜주는 목표 관리 앱입니다.

[v1.0.0 업데이트 기능] 
- ✍️ 목표 작성: 간단한 제목과 함께 구체적인 목표 내용을 기록해보세요.
- 🔔 알림 기능: 설정한 날짜에 맞춰 푸시 알림으로 목표를 리마인드합니다.
- 📈 자기 피드백: 목표를 달성한 후, 직접 달성도를 평가하고 스스로에게 피드백을 남겨보세요.
- 📊 나의 성장 추적: 반복적인 피드백과 기록을 통해 목표 달성 습관을 만들어갑니다.

---

## ⚙️ 주요 기능

- Figma 기반 UI 설계 및 화면 구성
- Flutter OAuth 라이브러리를 이용한 구글/카카오 OAuth 2.0 로그인 구현
- 백엔드와 연동된 JWT 인증 (Access/Refresh Token Rotation(RTR))
- `flutter_secure_storage` 및 커스텀 TokenStorage 클래스를 통한 보안 토큰 저장 및 갱신
- Dio Interceptor를 통한 JWT 자동 삽입, 에러 핸들링, 재시도, 로그아웃 처리
- Riverpod 기반 전역/로컬 상태 관리
- GoRouter를 이용한 동적 URI 및 딥링크 라우팅
- MVVM + Repository 패턴 구조(Screen / Service / Provider / DTO / API)
- ShowcaseView를 활용한 온보딩 및 기능 가이드 구현

---

## 🛠 기술 스택

- **Flutter** (3.32.2), **Dart 3.8.1**
- **Dio**, **GoRouter**, **Riverpod**
- **OAuth 로그인**: `google_sign_in`, `kakao_flutter_sdk_user`, `flutter_naver_login`
- **flutter_secure_storage**, **shared_preferences**
- **FCM**, **flutter_local_notifications**
- **ShowcaseView**, **Lottie**
