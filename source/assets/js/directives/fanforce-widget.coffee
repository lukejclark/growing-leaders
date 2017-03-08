App.directive('fanforceWidget', ['$http','$compile', ($http, $compile) ->
  restrict: 'A',
  scope: {}
  link: (($scope, $element, attrs) ->
    FF(->
      FF.applyBindings($element)
    )
  )
])