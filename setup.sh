#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"
CLAUDE_DIR="$HOME/.claude"

echo "=== dotfiles 설정 시작 ==="

# .claude 디렉토리 생성
mkdir -p "$CLAUDE_DIR"

# statusline 스크립트 심볼릭 링크
ln -sf "$DOTFILES/claude/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
chmod +x "$CLAUDE_DIR/statusline-command.sh"
echo "✓ statusline-command.sh 연결됨"

# CLAUDE.md 심볼릭 링크
ln -sf "$DOTFILES/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "✓ CLAUDE.md 연결됨"

# settings.json: 템플릿에서 생성 (토큰은 직접 입력)
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
  cp "$DOTFILES/claude/settings.json.template" "$CLAUDE_DIR/settings.json"
  echo ""
  echo "⚠️  settings.json이 생성됐습니다."
  echo "   $CLAUDE_DIR/settings.json 에서 YOUR_GITHUB_TOKEN_HERE를 실제 토큰으로 교체하세요."
else
  echo "✓ settings.json 이미 존재 (건너뜀)"
fi

echo ""
echo "=== 완료! Claude Code를 재시작하세요. ==="
