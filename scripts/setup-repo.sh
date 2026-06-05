#!/usr/bin/env bash
# scripts/setup-repo.sh
# Configure les secrets et paramètres GitHub pour le repo
# Usage: bash scripts/setup-repo.sh <owner/repo>

set -euo pipefail

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"

echo "🔧 Configuration du repo : $REPO"

# ── Branch protection ──────────────────────────
echo "📌 Configuration de la protection de branche (main)..."
gh api "repos/$REPO/branches/main/protection" \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["Tests Python 3.12","Lint & Format","Type Check (mypy)"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  2>/dev/null && echo "  ✅ Protection de branche configurée" || echo "  ⚠️ Erreur — vérifiez les permissions"

# ── Labels ─────────────────────────────────────
echo "🏷️  Création des labels..."
declare -A LABELS=(
  ["bug"]="d73a4a"
  ["enhancement"]="a2eeef"
  ["dependencies"]="0075ca"
  ["documentation"]="0075ca"
  ["security"]="ee0701"
  ["automated"]="7057ff"
  ["stale"]="ededed"
  ["size/XS"]="3cbf00"
  ["size/S"]="5d9801"
  ["size/M"]="7f6f00"
  ["size/L"]="b45309"
  ["size/XL"]="b91c1c"
  ["📦 dependencies"]="0075ca"
  ["🔒 security"]="ee0701"
  ["⚙️ ci/cd"]="e4e669"
  ["📚 docs"]="0075ca"
  ["🧪 tests"]="7057ff"
)

for label in "${!LABELS[@]}"; do
  color="${LABELS[$label]}"
  gh label create "$label" --color "$color" --repo "$REPO" 2>/dev/null \
    || gh label edit "$label" --color "$color" --repo "$REPO" 2>/dev/null \
    || true
done
echo "  ✅ Labels créés"

# ── Environments ───────────────────────────────
echo "🌍 Création des environnements..."
for env in "testpypi" "pypi" "github-pages"; do
  gh api "repos/$REPO/environments/$env" --method PUT 2>/dev/null || true
done
echo "  ✅ Environnements créés (configurer les secrets manuellement)"

# ── Secrets recommandés ────────────────────────
echo ""
echo "📋 Secrets à configurer manuellement dans Settings > Secrets :"
echo "   - SLACK_WEBHOOK_URL   : Webhook Slack pour les notifications"
echo "   - CODECOV_TOKEN       : Token Codecov pour la couverture"
echo ""
echo "✅ Setup terminé pour $REPO"
echo "🔗 Voir : https://github.com/$REPO/settings"
