#!/usr/bin/env bash
# prompt-reviewer 플러그인 설치 스크립트
# 사용법: bash install.sh
#
# 이 스크립트는 prompt-reviewer 플러그인을 OpenCode에 등록합니다.
# 설치 후 OpenCode를 재시작하면, prompt-review: 트리거가
# 모든 세션에서 최우선으로 동작합니다.

set -euo pipefail

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 경로 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
PLUGIN_SOURCE="${SCRIPT_DIR}/prompt-reviewer.js"
CONFIG_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
PLUGIN_DIR="${CONFIG_DIR}/plugin"
PLUGIN_LINK="${PLUGIN_DIR}/prompt-reviewer.js"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   prompt-reviewer 플러그인 설치           ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# 1. 플러그인 소스 파일 확인
if [ ! -f "$PLUGIN_SOURCE" ]; then
  echo -e "${RED}✗ 오류: 플러그인 파일을 찾을 수 없습니다${NC}"
  echo "  경로: $PLUGIN_SOURCE"
  exit 1
fi

echo -e "${GREEN}✓${NC} 플러그인 소스 확인: $PLUGIN_SOURCE"

# 2. plugin 디렉토리 생성 (없으면)
if [ ! -d "$PLUGIN_DIR" ]; then
  mkdir -p "$PLUGIN_DIR"
  echo -e "${GREEN}✓${NC} plugin 디렉토리 생성: $PLUGIN_DIR"
else
  echo -e "${GREEN}✓${NC} plugin 디렉토리 확인: $PLUGIN_DIR"
fi

# 3. 기존 심링크/파일 정리
if [ -e "$PLUGIN_LINK" ] || [ -L "$PLUGIN_LINK" ]; then
  rm -f "$PLUGIN_LINK"
  echo -e "${YELLOW}→${NC} 기존 플러그인 링크 제거"
fi

# 4. 심링크 생성
ln -s "$PLUGIN_SOURCE" "$PLUGIN_LINK"
echo -e "${GREEN}✓${NC} 심링크 생성: $PLUGIN_LINK → $PLUGIN_SOURCE"

# 5. SKILL.md 확인
SKILL_FILE="${SKILL_DIR}/SKILL.md"
if [ -f "$SKILL_FILE" ]; then
  echo -e "${GREEN}✓${NC} SKILL.md 확인: $SKILL_FILE"
else
  echo -e "${YELLOW}⚠${NC} SKILL.md를 찾을 수 없습니다: $SKILL_FILE"
fi

# 6. 결과 출력
echo ""
echo "══════════════════════════════════════════"
echo -e "${GREEN}설치 완료!${NC}"
echo ""
echo "다음 단계:"
echo "  1. OpenCode를 재시작하세요"
echo "  2. 아무 세션에서 prompt-review: 트리거를 테스트하세요"
echo ""
echo "예시:"
echo "  prompt-review: build a login page"
echo "  [analyze-mode] prompt-review: refactor the auth module"
echo ""
echo "제거하려면:"
echo "  rm $PLUGIN_LINK"
echo "══════════════════════════════════════════"
echo ""
