# babel-plugin-module-deps

This Babel plugin redefines `require` within all (CJS) modules to record any
required modules in an array of resolved filenames called `module.deps`.
(Note that the array may have duplicates.)
It only works with
[Node.js CommonJS modules](https://nodejs.org/api/modules.html)
(though with
[@babel/plugin-transform-modules-commonjs](https://www.npmjs.com/package/@babel/plugin-transform-modules-commonjs)
you can still use ESM syntax).

The `module.deps` arrays let a tool later discover what other modules
each module depends on, by inspecting `require.cache[filename].deps`.
This can be useful to deep-reload a module, or to detect when a module
should be called according to whether a generated file is older
than the module or dependency code.

## Usage

Add the module as a plugin to your Babel configuration, as in:

```json
{
  "plugins": ["babel-plugin-module-deps"]
}
```

Generally you want this plugin to run last,
so [list it last](https://babeljs.io/docs/en/plugins#plugin-ordering)
in the `"plugins"` array.
In particular, this plugin should run after
[@babel/plugin-transform-modules-commonjs](https://www.npmjs.com/package/@babel/plugin-transform-modules-commonjs)
(if you're using ESM syntax in CJS),
so that `require` is redefined before `import`s get executed
(as they are simulated by `require`).

Then you can access the current module's dependencies via `module.deps`,
or an arbitrary module's dependencies via `require.cache[filename].deps`,
where `filename` is the `require.resolve`d filename for a module.

## Recursive Dependencies

If you've just run `require(modname)` with
[@babel/register](https://babeljs.io/docs/en/babel-register/)
configured to run this plugin, then calling the function below as
`walkDeps(modname)` should give an array of all recursive module dependencies
that `modname` `require`s or `import`s as `require.resolve`d filenames
(including `require.resolve(modname)` itself`, but excluding duplicates).

```js
function walkDeps(modname) {
  const deps = {};
  function recurse(submodname) {
    deps[submodname] = true;
    const submod = require.cache[submodname];
    if (!submod) return;
    const subdeps = require.cache[submodname].deps;
    if (!subdeps) return;
    for (dep of subdeps)
      if (!dep in deps)
        recurse(dep);
  }
  recurse(require.resolve(modname));
  return Object.keys(deps);
}
```
