// Package an already-tested Flutter release using Vercel Build Output API v3.
// Does not log in, upload, publish, or create/change a Vercel project.
import { mkdir, cp, writeFile, access } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const build = path.join(root, 'build', 'web');
const output = path.join(root, '.vercel', 'output');
await access(path.join(build, 'main.dart.js'));
await mkdir(path.join(output, 'static'), { recursive: true });
await cp(build, path.join(output, 'static'), { recursive: true });
await writeFile(path.join(output, 'config.json'), JSON.stringify({
  version: 3,
  routes: [
    { src: '/.*', headers: { 'Cache-Control': 'public, max-age=0, must-revalidate' }, continue: true },
    { handle: 'filesystem' },
    { src: '/.*', dest: '/index.html' }
  ]
}, null, 2));
console.log('Prepared .vercel/output. Link to your EXISTING project before deploying.');
