# 1. تعريف المتغيرات (Variables)
$BASE_HREF = "/"
$GITHUB_REPO = "https://github.com/fagerhu03/WebPortfolio.git"
# ملاحظة: استخدمت رابط https لأنه أسهل، إذا كنت تستخدم SSH ووضعت مفاتيحك يمكنك تغييره إلى:
# $GITHUB_REPO = "git@github.com:fagerhu03/Web_Portfolio.git"

# 2. استخراج رقم الإصدار من pubspec.yaml تلقائياً (بديل grep و awk)
$VersionLine = Get-Content pubspec.yaml | Select-String "^version:"
$BUILD_VERSION = $VersionLine.ToString().Split(":")[1].Trim()

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " Building Flutter Web (Version: $BUILD_VERSION)" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan

# 3. عمل Build
flutter build web --base-href $BASE_HREF

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " Deploying v$BUILD_VERSION to GitHub Pages..." -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Cyan

# 4. رفع الملفات إلى GitHub
cd build\web
git init
git add .
git commit -m "Deploy version $BUILD_VERSION"
git push --force $GITHUB_REPO HEAD:gh-pages

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " Deployment Complete for v$BUILD_VERSION!" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan


cd ..\..