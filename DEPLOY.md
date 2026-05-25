# Deploy LuxeLaptops to GitHub Pages

Your site will be live at:

`https://<your-github-username>.github.io/<repo-name>/`

Example: `https://johndoe.github.io/luxelaptops/`

## One-time setup (about 5 minutes)

### 1. Create a GitHub repository

1. Open [https://github.com/new](https://github.com/new)
2. Repository name: `luxelaptops` (or any name — the workflow adapts automatically)
3. **Public** repository (required for free GitHub Pages)
4. Do **not** add README, .gitignore, or license (this project already has them)
5. Click **Create repository**

### 2. Push this project from your PC

In PowerShell (replace `YOUR_USERNAME` and `REPO_NAME`):

```powershell
cd C:\Users\WALID\Projects\luxelaptops
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
git push -u origin main
```

If GitHub asks you to sign in, use a [Personal Access Token](https://github.com/settings/tokens) as the password, or sign in with GitHub Desktop.

### 3. Enable GitHub Pages

1. On GitHub, open your repo → **Settings** → **Pages**
2. Under **Build and deployment**, set **Source** to **GitHub Actions**
3. Save (no branch selection needed — the workflow handles deploy)

### 4. Wait for the first deploy

1. Open the **Actions** tab in your repo
2. Wait for **Deploy to GitHub Pages** to finish (green checkmark, ~3–5 min)
3. Open the URL shown in the workflow run, or under **Settings → Pages**

## Updates

Every `git push` to `main` rebuilds and redeploys the site automatically.

```powershell
git add .
git commit -m "Your change description"
git push
```

## Troubleshooting

| Problem | Fix |
|--------|-----|
| Blank white page | Repo name in URL must match GitHub repo name exactly |
| Images missing | Ensure `lib/assets/*.jpg` are committed and listed in `pubspec.yaml` |
| Workflow failed | Open **Actions** → click the failed run → read the error log |
| 404 on GitHub Pages | Enable **Source: GitHub Actions** under Settings → Pages |
