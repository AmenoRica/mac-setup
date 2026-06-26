# Mac Setup

맥 초기 설정을 최소 동작으로 재현하기 위한 저장소입니다.

## 처음 실행

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone <this-repo-url> ~/mac-setup
cd ~/mac-setup
./bootstrap.sh
```

## 파일

- `Brewfile`: Homebrew 패키지와 앱 목록
- `README.md`: 설정 방법 설명
- `bootstrap.sh`: 설정 진입점

## 자동 설정

`bootstrap.sh`는 `brew bundle` 실행 후 아래 설정을 적용합니다.

- Codex 테마: Catppuccin Latte 기반, Rosewater 포인트 컬러
- Nerd Fonts Symbols Only: Nerd Font 심볼 전용 폰트 설치
- VS Code: Catppuccin Latte 테마, Rosewater 포인트 컬러, 통합 글꼴
- 통합 글꼴: Yutapon VS Code 패치 폰트에 온글잎 긍정 한글 글리프와 Symbols Nerd Font 심볼 글리프 병합
- Ghostty: Catppuccin Latte 테마, 통합 글꼴, 불투명도 80%, 상하좌우 여백
- Starship: 공식 Jetpack preset

## 주의사항

Steam은 Intel macOS 앱이라 Apple Silicon Mac에서 Rosetta 2가 필요합니다.
필요하면 직접 터미널에서 설치합니다.

```sh
softwareupdate --install-rosetta --agree-to-license
```

Rosetta 2는 설치 후 제거가 어렵습니다.

## 수동 설치

Codex, VS Code, Ghostty는 `Yutapon Coding VSCode Integrated`를 우선 사용합니다.
이 통합 폰트는 아래 폰트를 재료로 로컬 `~/Library/Fonts`에 생성합니다.

- [Yutapon Coding](https://www.freejapanesefont.com/yutapon-coding-font-download)
- [온글잎 긍정](https://www.ownglyph.com/trial/0c49e349-2997-43c8-b267-82dcdd2c632f)
- [Symbols Nerd Font](https://www.nerdfonts.com/font-downloads)

Yutapon Coding과 온글잎 긍정 설치 후 `bootstrap.sh`를 실행하면 `Symbols Nerd Font`를 Nerd Fonts에서 내려받고,
VS Code용 패치 폰트인 `Yutapon Coding VSCode`와 통합 폰트인 `Yutapon Coding VSCode Integrated`를 생성합니다.
VS Code/Monaco가 공백을 NBSP로 렌더링할 때 Yutapon의 NBSP 글리프가 보이는 문제를 막기 위해 NBSP는 일반 공백 글리프로 매핑합니다.
통합 폰트가 심볼을 빠뜨리는 앱에 대비해 일부 설정에는 `Symbols Nerd Font`도 fallback으로 남깁니다.
