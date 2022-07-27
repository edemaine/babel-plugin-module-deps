module.exports = ({types}) ->
  program = null
  visitor:
    Program: (path) ->
      program = path
      undefined
  post: ->
      program.unshiftContainer 'body',
        types.expressionStatement types.assignmentExpression(
          '='
          types.identifier 'require'
          types.callExpression(
            types.arrowFunctionExpression(
              [types.identifier 'r']
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
            )
            [types.identifier 'require']
          )
        )
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
