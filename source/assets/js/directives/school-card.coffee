App.directive('schoolCard', ['$http','$compile', ($http, $compile) ->
  restrict: 'E',
  scope: {
    school: '=?'
    name: '@?'
    raised: '@?'
  }
  templateUrl: '/directives/school-card'
  link: (($scope, $element, attrs) ->
    $scope.backers ||= 0
    $scope.total ||= 5000

    $scope.school ||= {}
    $scope.school.name = $scope.name if $scope.name
    $scope.school_id = $scope.school._id

    $scope.raised = parseInt($scope.raised || 0) || 0
    $scope.percent_raised = if $scope.raised then (($scope.raised / $scope.total) * 100) else 0
    $scope.backers = 3 if !$scope.backers and $scope.percent_raised > 0

    $element.addClass('fully-funded') if $scope.percent_raised == 100

    $scope.viewSchool = ((e)->
      window.location.href = FF.insertSharableToken("/schools/#{$scope.school_id}")
    )
    $scope.openDonate = $scope.$root.openDonate

    FF(->
      $scope.sharable_token = FF.visitor.sharable_token
    )
  )
])