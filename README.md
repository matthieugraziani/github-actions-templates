# 🤖 GitHub Workflows Template

Template exhaustif des automatisations GitHub Actions pour un projet Python professionnel.

## 📋 Workflows inclus

| Workflow | Déclencheur | Description |
|---|---|---|
| [`ci.yml`](.github/workflows/ci.yml) | push, PR | Tests, lint, type check, couverture |
| [`release.yml`](.github/workflows/release.yml) | tag `v*.*.*` | Build, publish PyPI, GitHub Release |
| [`security.yml`](.github/workflows/security.yml) | push, schedule | SAST, audit deps, scan secrets, licences |
| [`deps-update.yml`](.github/workflows/deps-update.yml) | schedule | Mise à jour auto des dépendances |
| [`docs.yml`](.github/workflows/docs.yml) | push docs/ | Build MkDocs, deploy GitHub Pages, CHANGELOG |
| [`automation.yml`](.github/workflows/automation.yml) | issues, PRs | Labels auto, stale, welcome, auto-merge |
| [`performance.yml`](.github/workflows/performance.yml) | push, PR | Benchmarks, couverture détaillée |
| [`docker.yml`](.github/workflows/docker.yml) | push, tag | Build multi-arch, scan Trivy, push GHCR |
| [`notifications.yml`](.github/workflows/notifications.yml) | workflow_run, schedule | Slack, rapport hebdo |
| [`_reusable-setup.yml`](.github/workflows/_reusable-setup.yml) | `workflow_call` | Job réutilisable (setup Python) |

## 🗂️ Structure

```
.
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                  # CI — Tests & Qualité
│   │   ├── release.yml             # CD — Release & Publish PyPI
│   │   ├── security.yml            # Sécurité (SAST, audit, secrets)
│   │   ├── deps-update.yml         # Mise à jour des dépendances
│   │   ├── docs.yml                # Documentation & CHANGELOG
│   │   ├── automation.yml          # Gestion issues & PRs
│   │   ├── performance.yml         # Benchmarks & couverture
│   │   ├── docker.yml              # Build & push Docker
│   │   ├── notifications.yml       # Alertes & rapports
│   │   └── _reusable-setup.yml     # Workflow réutilisable
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   └── feature_request.yml
│   ├── PULL_REQUEST_TEMPLATE/
│   │   └── pull_request_template.md
│   ├── dependabot.yml              # Config Dependabot
│   └── labeler.yml                 # Auto-labels PRs
├── scripts/
│   └── setup-repo.sh               # Script de config initiale
└── cliff.toml                      # Config changelog (git-cliff)
```

## 🚀 Démarrage rapide

### 1. Copier dans votre projet

```bash
# Copier tous les fichiers .github/ dans votre repo
cp -r .github/ /path/to/your/project/
cp cliff.toml /path/to/your/project/
```

### 2. Configurer le repo GitHub

```bash
# Prérequis : gh CLI installé et authentifié
bash scripts/setup-repo.sh owner/mon-repo
```

### 3. Configurer les secrets nécessaires

Dans **Settings → Secrets and variables → Actions** :

| Secret | Requis pour | Description |
|---|---|---|
| `SLACK_WEBHOOK_URL` | `notifications.yml` | Webhook Slack (optionnel) |
| `CODECOV_TOKEN` | `ci.yml` | Token Codecov (optionnel) |

> **Note :** PyPI utilise le **Trusted Publishing** (OIDC) — aucun token PyPI à stocker.

### 4. Activer GitHub Pages

Dans **Settings → Pages** :
- Source : **GitHub Actions**

---

## ⚙️ Personnalisation

### CI (`ci.yml`)

```yaml
# Adapter la matrice Python
matrix:
  python-version: ["3.11", "3.12"]  # Ajouter 3.13 si besoin
```

### Dependabot (`dependabot.yml`)

```yaml
# Changer la fréquence
schedule:
  interval: "daily"  # ou "weekly", "monthly"
```

### CHANGELOG (`cliff.toml`)

Le projet utilise les **Conventional Commits** :
- `feat:` → ✨ Nouvelles fonctionnalités
- `fix:` → 🐛 Corrections
- `perf:` → ⚡ Performances
- `docs:` → 📚 Documentation
- `chore(deps):` → 📦 Dépendances

---

## 📊 Vue d'ensemble des déclencheurs

```
Push main  ──→ CI + Security + Docs + Docker + Notifications
Push tag   ──→ Release + Docker + GitHub Release
PR         ──→ CI + Security + Auto-labels + Size check
Schedule   ──→ Deps update (lundi 6h) + Rapport (lundi 9h) + Stale
Manual     ──→ Tous les workflows (workflow_dispatch)
```

---

## 🔗 Ressources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Marketplace](https://github.com/marketplace?type=actions)
- [git-cliff](https://git-cliff.org/)
- [Trusted Publishing PyPI](https://docs.pypi.org/trusted-publishers/)
