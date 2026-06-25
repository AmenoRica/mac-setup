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

## 주의사항

Steam은 Intel macOS 앱이라 Apple Silicon Mac에서 Rosetta 2가 필요합니다.
필요하면 직접 터미널에서 설치합니다.

```sh
softwareupdate --install-rosetta --agree-to-license
```

Rosetta 2는 설치 후 제거가 어렵습니다.
