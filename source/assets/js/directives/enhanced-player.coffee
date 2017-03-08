App.directive('enhancedPlayer', ['$http','$compile', ($http, $compile) ->
  restrict: 'A',
  link: (($scope, $element, attrs) ->
    $widget = $element.find('ff-vimeo-player')

    $scope.playVideo = ((e)->
      $scope.is_maximized = true
      FF.widget($widget).play()
    )

    FF(->
      FF.widget($widget).on('ready', ->
        $scope.is_ready = true
      )
    )
  )
])