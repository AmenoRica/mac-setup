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

`bootstrap.sh`는 `brew bundle install --no-upgrade` 실행 후 아래 설정을 적용합니다.
재실행할 때 이미 설치된 앱을 자동 업그레이드하지 않으므로 실행 중인 Codex 같은 앱을 건드리지 않습니다.

- 런타임 버전 관리: mise로 Node.js/npm/Python 기본 버전 관리
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

## Node.js/npm/Python 버전 관리

Node.js, npm, Python은 Homebrew의 개별 런타임 패키지를 직접 쓰지 않고 `mise`로 관리합니다.
`bootstrap.sh`는 Homebrew로 `mise`를 설치한 뒤 `config/mise/config.toml`을 `~/.config/mise/config.toml`에 복사하고,
`~/.zshrc`에 아래 활성화 구문을 추가합니다.

```sh
eval "$(mise activate zsh)"
```

기본 버전은 아래처럼 설정합니다.

```toml
[tools]
node = "lts"
python = "latest"
```

Node.js는 LTS를 기본으로 쓰며 npm은 Node.js에 포함된 버전을 사용합니다.
Python은 Node.js처럼 LTS 채널이 없어서 최신 안정 버전을 기본으로 둡니다.

현재 셸에서 바로 적용하려면 새 터미널을 열거나 아래 명령을 실행합니다.

```sh
source ~/.zshrc
```

설치된 버전은 아래 명령으로 확인합니다.

```sh
node --version
npm --version
python --version
mise ls
```

기본 버전을 바꾸려면 저장소의 `config/mise/config.toml`을 수정한 뒤 다시 `./bootstrap.sh`를 실행합니다.
`scripts/apply-vscode-settings.sh`도 이 파일의 Node.js 기본 버전을 읽어 설정 업데이트에 사용합니다.
특정 프로젝트만 다른 버전을 써야 하면 해당 프로젝트 안에서 `mise use node@20`처럼 실행해 프로젝트용 `mise.toml`을 만듭니다.

`bootstrap.sh`는 기존 Homebrew `node`/`npm`/`python@3.14`가 단독 설치되어 있으면 제거합니다.
다른 Homebrew 패키지가 의존하는 런타임은 강제로 제거하지 않습니다.

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
