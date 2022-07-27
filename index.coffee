module.exports = ({types}) ->
  program = null
  visitor:
    Program: (path) ->
      program = path
      undefined
  post: ->
    ## Prepend JavaScript code:
    ##     require = ((r) =>
    ##       Object.assign(
    ##         (id) => (module.deps.push(r.resolve(id)), r(id)),
    ##         r
    ##       )
    ##     )(require);
    ## The `Object.assign` copies over enumerable properties
    ## (`resolve`, `main`, `extensions`, `cache`) from the `require` object
    ## to the new function which pushes to `module.deps` and calls `require`.
    program.unshiftContainer 'body',
      types.expressionStatement types.assignmentExpression(
        '='
        types.identifier 'require'
        types.callExpression(
          types.arrowFunctionExpression(
            [types.identifier 'r']
            types.callExpression(
              types.memberExpression(
                types.identifier 'Object'
                types.identifier 'assign'
              )
              [
                types.arrowFunctionExpression(
                  [types.identifier 'id']
                  types.sequenceExpression [
                    types.callExpression(
                      types.memberExpression(
                        types.memberExpression(
                          types.identifier 'module'
                          types.identifier 'deps'
                        )
                        types.identifier 'push'
                      )
                      [types.callExpression(
                        types.memberExpression(
                          types.identifier 'r'
                          types.identifier 'resolve'
                        )
                        [types.identifier 'id']
                      )]
                    )
                    types.callExpression(
                      types.identifier 'r'
                      [types.identifier 'id']
                    )
                  ]
                )
                types.identifier 'r'
              ]
            )
          )
          [types.identifier 'require']
        )
      )
    ## Prepend JavaScript code: module.deps = [];
    ## Because this gets prepended last, it ends up being the first line.
    program.unshiftContainer 'body',
      types.expressionStatement types.assignmentExpression(
        '='
        types.memberExpression(
          types.identifier 'module'
          types.identifier 'deps'
        )
        types.arrayExpression()
      )
    undefined
