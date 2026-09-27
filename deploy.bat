@echo off
echo ===================================
echo  Building Flutter Web...
echo ===================================
call flutter build web --base-href "/Web_Portfolio/"

echo ===================================
echo  Deploying to GitHub Pages...
echo ===================================
cd build\web
git init
git add .
git commit -m "Auto-deploy update"
git push --force https://github.com/fagerhu03/Web_Portfolio.git HEAD:gh-pages

echo ===================================
echo  Deployment Complete!
echo ===================================
cd ..\..