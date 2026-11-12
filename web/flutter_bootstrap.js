// Custom Flutter web bootstrap for the local-only application.
// The loader detects Wasm support and retains the JavaScript fallback.
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    wasmAllowList: { blink: true, webkit: true, gecko: true },
  },
});
