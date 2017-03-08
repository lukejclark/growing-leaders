_current_modal = null

(@VisitorCtrl = ($scope, $modal)->
  $scope.$safeApply = Utils.$safeApply
  $scope.visitor = cachedVisitor() || {
    school_invested: '--'
    school_influenced: '--'
    students_impacted: '--'
  }
  $scope.visitor.is_logged_in = true if Cookie.get('is_logged_in') == '1'

  $scope.register = (->
    try (_current_modal.close() if _current_modal) catch err
    _current_modal = current_modal = $modal.open(
      templateUrl: '/template/auth/register',
      scope: $scope
      windowClass: 'register'
    )
    current_modal.opened.then(->
      $('headroom').addClass('register-is-opened')
    )
    current_modal.result.finally(->
      $('headroom').removeClass('register-is-opened')
    )
  )

  $scope.login = (->
    try (_current_modal.close() if _current_modal) catch err
    _current_modal = current_modal = $modal.open(
      templateUrl: '/template/auth/login',
      scope: $scope
      windowClass: 'login'
    )
    current_modal.opened.then(->
      $('headroom').addClass('login-is-opened')
    )
    current_modal.result.finally(->
      $('headroom').removeClass('login-is-opened')
    )
  )

  $scope.lostPassword = (->
    try (_current_modal.close() if _current_modal) catch err
    _current_modal = $modal.open(
      templateUrl: '/template/auth/lost-password',
      scope: $scope
      windowClass: 'lost-password'
    )
  )

  $scope.showWelcome = (->
    try (_current_modal.close() if _current_modal) catch err
    _current_modal = $modal.open(
      templateUrl: '/template/auth/welcome',
      scope: $scope
      windowClass: 'welcome'
    )
  )

  $scope.logout = (->
    Cookie.set('is_logged_in', '0')
    $scope.visitor.is_logged_in = false
    $scope.visitor.school_invested = 0
    $scope.visitor.school_influenced = 0
    $scope.visitor.students_impacted = 0
    setCachedVisitor($scope.visitor)
  )

  FF(->
    setVisitor($scope)
    FF.app('simple-auth').on('register', ->
      $scope.showWelcome()

    ).on('login', (data)->
      angular.extend($scope.visitor,
        name: data.name || "#{data.first_name} #{data.last_name}"
        first_name: data.first_name
        last_name: data.last_name
      )
      finishLogin($scope, data)
      setCachedVisitor($scope.visitor)

    ).on('logout', (data)->
      $scope.visitor = {}
      $scope.$safeApply()
    )
  )

).$inject = ['$scope','$modal']

finishLogin = (($scope)->
  Cookie.set('is_logged_in', '1')
  _current_modal.close() if _current_modal
  _current_modal = null
  $scope.visitor.is_logged_in = true
  $scope.$safeApply()
)

cachedVisitor = (->
  raw_json = Cookie.get('visitor_data')
  return if !raw_json
  JSON.parse(raw_json)
)

setCachedVisitor = ((visitor)->
  Cookie.set('visitor_data', JSON.stringify(visitor))
)

setVisitor = (($scope)->
  FF.visitor ((visitor)->
    angular.extend($scope.visitor,
      name: visitor.name
      first_name: visitor.first_name
      last_name: visitor.last_name
      school_invested: 0,
      school_influenced: 0,
      students_impacted: 0,
    )
    setCachedVisitor($scope.visitor)
    $scope.$safeApply()
  )
)