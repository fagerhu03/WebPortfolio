# Deploy to the existing Vercel project

The current live domain is **fager-hussien-portfolio.vercel.app**.
The files are ready for deployment; this rebuild does not publish automatically.

## Recommended: deploy the tested local build

Prerequisites: Flutter 3.38.7 / Dart 3.10.7, Node.js, and access to your existing
Vercel account/project. Run these commands from the Flutter project root.

```powershell
flutter pub get
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn --pwa-strategy=none
node tool/prepare-vercel.mjs
```

The packaging command produces `.vercel/output` using Vercel's Build Output API.
It does not upload or alter the live site.

```powershell
npx vercel login
npx vercel link
```

Select the account/team that owns the live portfolio, choose **link to an existing
project**, and choose the project associated with the domain above. Do not create
a second project. The public domain does not prove the project's internal name,
so use the Vercel dashboard to confirm the selection.

Inspect `.vercel/project.json` to confirm the linked project, then create a preview:

```powershell
npx vercel deploy --prebuilt
```

Review the preview at desktop and mobile widths. Test the theme toggle, reload to
check persistence, browse the featured gallery, and check the contact links.
When ready to replace the live site:

```powershell
npx vercel deploy --prebuilt --prod
```

The prebuilt route uses the already-tested files and bypasses any old framework
build settings. It needs no Flutter installation on Vercel. Keep the existing
project/domain association; Vercel will publish to that project's production domain.

## Alternative: Git-based builds on Vercel

Commit the source to the repository connected to the existing Vercel project.
Ensure Vercel's Root Directory points to this Flutter project. `vercel.json`
selects Other/no framework, runs `bash tool/vercel-build.sh`, and serves `build/web`.
The script fetches a pinned Flutter 3.38.7 SDK from the official Flutter repository.
If old project-level overrides conflict, set Framework Preset to Other, Build
Command to `bash tool/vercel-build.sh`, and Output Directory to `build/web`.
The first cloud build downloads the SDK and therefore takes longer than prebuilt
deployment. This cloud path is supplied but was not executed against your account.

## Local preview

```powershell
python -m http.server 8765 --directory build/web
```

Open http://localhost:8765. Do not open `index.html` directly as a local file.
Navigation uses URL fragments, so `/​#work`, `/​#about` and `/​#contact` share the
same page. The site has no server, API keys or backend configuration.

The release bundles fonts and CanvasKit locally. Service-worker caching is off
to avoid old portfolio releases getting stuck in visitors' caches. If a previous
deployment installed a service worker, test an update in a previously used browser
profile as well as a private window.

References: [Flutter web release guide](https://docs.flutter.dev/deployment/web),
[Vercel deploy CLI](https://vercel.com/docs/cli/deploy),
[Vercel Build Output API](https://vercel.com/docs/build-output-api/v3).
