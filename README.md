
# 📱 Re_Tap Frontend

> 📌 [English](#english) | 🇰🇷 [한국어](#korean)

---

# English

## 📱 Re_Tap Frontend

The frontend for Re_Tap, a personal goal management app that helps users form habits and stay motivated.  
This Flutter-based mobile application integrates secure authentication, token management, push notifications, and dynamic routing with a polished UI/UX.

---

## 🧠 About

Re_Tap allows users to define and lock goals, receive feedback, and interact with guided routines.  
The frontend is designed using MVVM and Repository patterns, ensuring clean state separation, secure token handling, and smooth user flows.

---

## ⚙️ Key Features

- Figma-based UI design and layout
- Google & Kakao OAuth 2.0 login via Flutter OAuth libraries
- JWT integration with backend (Access/Refresh Token)
- Secure token storage using `flutter_secure_storage` and custom TokenStorage class
- Dio Auth Interceptor for token injection, error handling, retry, and logout logic
- Global/local state management with Riverpod
- Routing with GoRouter for dynamic URI and deep link support
- MVVM + Repository architecture: Screen / Service / Provider / DTO / API(Dio)
- Onboarding guide with ShowcaseView

---

## 🛠 Tech Stack

- **Flutter** (3.x), **Dart 3.x**
- **Dio**, **GoRouter**, **Riverpod**
- **OAuth Libraries**: `google_sign_in`, `kakao_flutter_sdk_user`, `flutter_naver_login`
- **flutter_secure_storage**, **shared_preferences**
- **FCM**, **flutter_local_notifications**
- **ShowcaseView**, **Lottie**

---

# Korean

## 📱 Re_Tap 프론트엔드

Re_Tap은 사용자의 목표 설정과 루틴 실천을 도와주는 개인 목표 관리 앱입니다.  
Flutter 기반으로 제작되었으며, 보안 인증, 푸시 알림, 상태 관리, 온보딩 등 다양한 기능을 완성도 높게 통합했습니다.

---

## 🧠 소개

사용자는 목표를 설정하고 잠금 설정, 피드백을 통해 루틴을 유지할 수 있습니다.  
MVVM + Repository 패턴을 기반으로 설계하여, 상태 분리와 네트워크 로직을 효율적으로 관리합니다.

---

## ⚙️ 주요 기능

- Figma 기반 UI 설계 및 화면 구성
- Flutter OAuth 라이브러리를 이용한 구글/카카오 OAuth 2.0 로그인 구현
- 백엔드와 연동된 JWT 인증 (Access/Refresh Token)
- `flutter_secure_storage` 및 커스텀 TokenStorage 클래스를 통한 보안 토큰 저장 및 갱신
- Dio Interceptor를 통한 JWT 자동 삽입, 에러 핸들링, 재시도, 로그아웃 처리
- Riverpod 기반 전역/로컬 상태 관리
- GoRouter를 이용한 동적 URI 및 딥링크 라우팅
- MVVM + Repository 패턴 구조(Screen / Service / Provider / DTO / API)
- ShowcaseView를 활용한 온보딩 및 기능 가이드 구현

---

## 🛠 기술 스택

- **Flutter** (3.x), **Dart 3.x**
- **Dio**, **GoRouter**, **Riverpod**
- **OAuth 로그인**: `google_sign_in`, `kakao_flutter_sdk_user`, `flutter_naver_login`
- **flutter_secure_storage**, **shared_preferences**
- **FCM**, **flutter_local_notifications**
- **ShowcaseView**, **Lottie**
