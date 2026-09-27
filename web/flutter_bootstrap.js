{{flutter_js}}
{{flutter_build_config}}
const recoveryTimer=setTimeout(()=>{document.getElementById('recovery')?.style.setProperty('display','block');},20000);
_flutter.loader.load({onEntrypointLoaded:async engineInitializer=>{
  const appRunner=await engineInitializer.initializeEngine();
  await appRunner.runApp();
  clearTimeout(recoveryTimer);
  document.getElementById('loading')?.remove();
}});
