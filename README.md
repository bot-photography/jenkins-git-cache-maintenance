# 🧹 Jenkins Git Cache Maintenance

Automate Git cache and workspace cleanup for Jenkins agents and GitHub projects.

## 🚀 Features
- Cleans up cached Git repositories
- Runs safe garbage collection (`git gc --auto`)
- Optional aggressive cleanup (`git repack`, `git prune`)
- Deletes old Jenkins workspaces (> 30 days)
- Fully parameterized Jenkins pipeline

## ⚙️ Setup

1. Create a new Pipeline job in Jenkins.
2. Set SCM to your GitHub repo.
3. Run once with DRY_RUN=true to verify.

## ⏰ Schedule
Run weekly via cron: `H 3 * * 0`

## 🪪 License
MIT License © 2025
