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

