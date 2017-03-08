$http = null
(@SchoolsListCtrl = ($scope, _$http)->
  $http = _$http
  $scope.$safeApply = Utils.$safeApply
  $scope.stats = {funding_goal: ' --', funding_raised: ' --', total_backers: '---', funding_percentage: '--', school_count: '--', school_count_funded: '--'}

  $http.get("//#{DATA_DOMAIN}/schools").success((schools)->
    initiative_ids = []
    for school in schools
      initiative_ids.push(school.initiative_id) if school.initiative_id
      school.stats = {funding_goal: ' --', funding_raised: ' --', total_backers: '---', funding_percentage: '--'}
    $scope.schools = schools

    FF(-> @app 'crowdfunder', ->
      @stats(initiative_ids).success((stats_list)->
        $scope.stats = {funding_goal: 0, funding_raised: 0, total_backers: 0, funding_percentage: 0, school_count: 0, school_count_funded: 0}
        for school in $scope.schools
          continue if !school.initiative_id or !stats = stats_list[school.initiative_id]
          stats.funding_percentage = if stats.funding_goal then ((stats.funding_raised / stats.funding_goal) * 100) else 0
          for own k,v of stats
            school.stats[k] = Utils.numberWithCommas(v)
            $scope.stats[k] += v
          $scope.stats.school_count += 1
          $scope.stats.school_count_funded += 1 if stats.funding_goal and stats.funding_goal == stats.funding_raised
          school.stats.funding_percentage = Math.round(stats.funding_percentage)
        $scope.stats.funding_percentage = Math.round($scope.stats.funding_percentage)
        $scope.stats[k] = Utils.numberWithCommas(v) for own k,v of $scope.stats
        $scope.$safeApply()
      )
    )
  ).error((data, status, headers, config)->
    FF.error 'ERROR', data
  )
).$inject = ['$scope','$http']
