#!/bin/bash
# AI-Powered Code Review Helper

FILE="$1"

if [ -z "$FILE" ]; then
    echo "Usage: code-review.sh <file>"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

echo "🤖 Preparing code review for: $FILE"
echo ""
echo "To use with Claude:"
echo "  python claude_terminal.py interactive"
echo ""
echo "Then ask:"
echo "  'Review this code: $(cat $FILE)'"
echo ""
echo "Or use this prompt:"
echo "─────────────────────────────────────────"
cat << PROMPT
Please review this code for:
1. Security vulnerabilities
2. Code quality issues
3. Performance concerns
4. Best practice violations
5. Suggestions for improvement

Code:
\`\`\`
$(cat "$FILE")
\`\`\`
PROMPT
echo "─────────────────────────────────────────"
