# AGENTS.MD

이 저장소는 초기화한 macOS를 같은 취향으로 다시 설정하기 위한 개인 설정 저장소다.

## 프로젝트 고유 규칙

- 답변과 문서는 한국어로 작성한다.
- 사용자가 명시적으로 요청하지 않으면 커밋하지 않는다.
- 푸시는 커밋 요청과 별개다. 사용자가 따로 요청할 때만 푸시한다.
- 최상위에는 `.gitignore`, `Brewfile`, `README.md`, `bootstrap.sh`, `AGENTS.MD`만 둔다. 추가 파일은 하위 디렉토리에 둔다.
- 설정 변경은 “현재 Mac에 즉시 적용”과 “`bootstrap.sh`로 재현”을 모두 만족해야 한다.

## 현재 취향/결정

- 설명 문서는 한국어로 유지한다.
- Homebrew 계열 설치를 우선한다. App Store 앱은 `mas`, GUI 앱은 가능한 `cask`를 쓴다.
- 가능한 모든 프로그램은 Catppuccin Latte 기반과 Rosewater 포인트 컬러를 사용한다.
- 가능한 모든 프로그램은 `Yutapon Coding VSCode Integrated`를 우선 글꼴로 쓴다.
- 이 통합 폰트는 `Yutapon Coding VSCode` 기반에 `온글잎 긍정`의 한글 글리프와 `Symbols Nerd Font`의 Nerd Font 심볼 글리프를 합친 것이다.
- fallback이 필요한 설정에는 `Symbols Nerd Font`를 fallback으로 두고, `ComicShanns Nerd Font` 계열은 fallback으로 쓰지 않는다.
- 수동 설치 폰트는 README 링크만 남긴다. 폰트 파일 자체는 저장소에 넣지 않는다.
- Rosetta 2는 Steam 등 Intel 앱 때문에 필요할 수 있지만, 설치/제거 부담이 있으므로 README에 주의사항으로만 둔다.

- `Yutapon Coding VSCode`는 원본 Yutapon Coding의 NBSP 글리프가 VS Code/Monaco에서 공백 표시처럼 보이는 문제를 피하기 위한 중간 패치 폰트다.
- VS Code, Codex, Ghostty의 실제 우선 글꼴은 `Yutapon Coding VSCode Integrated`다.
- 통합 폰트는 `scripts/patch-yutapon-vscode-font.sh`가 로컬 `~/Library/Fonts`에 생성한다.
