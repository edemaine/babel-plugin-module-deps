# babel-plugin-module-deps

This Babel plugin redefines `require` within all (CJS) modules to record any
required modules in an array of resolved filenames called `module.deps`.
(Note that the array may have duplicates.)

This lets a tool later discover what other modules this module depends on,
by inspecting `require.cache[filename].deps`.

## Usage

Babel configuration:

```json
{
  "plugins": ["babel-plugin-module-deps"]
}
```
