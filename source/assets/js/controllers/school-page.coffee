$http = null
(@SchoolPageCtrl = ($scope, _$http)->
  $http = _$http
  $scope.$safeApply = Utils.$safeApply

  $scope.donation_amount = '$30'
  $scope.$watch('donation_amount', (donation_amount, old_donation_amount)->
    donation_amount = donation_amount.replace(/[^\d\.,]/g, '')
    $scope.donation_amount = '$' + donation_amount
  )

  $scope.$root.school_id = $scope.school_id = document.location.href.match(/[^#]+\/([^\/#]+)/)[1]
  $scope.stats = {funding_goal: ' --', funding_raised: ' --', total_backers: '---', funding_percentage: '--'}
  fetchSchool($scope)
).$inject = ['$scope','$http']

fetchSchool = (($scope)->
  $http.get("//#{DATA_DOMAIN}/schools/#{$scope.school_id}").success((school)->
    $scope.school = school
    $scope.school.name_short = school.name.replace('High School','').trim()
    FF(->
      @visitor.get('sharable_token', (s)-> $scope.sharable_token = s)
      @app('crowdfunder', ->
        @stats(school.initiative_id).success((stats)->
          stats.funding_percentage = if stats.funding_goal then Math.round((stats.funding_raised / stats.funding_goal) * 100) else 0
          $scope.stats[k] = Utils.numberWithCommas(v) for own k,v of stats
          $scope.$safeApply()
        )
        @recent_supporters(school.initiative_id).success((recent_supporters)->
          $scope.recent_supporters = recent_supporters
          $scope.$safeApply()
        )
        @top_influencers(school.initiative_id).success((top_influencers)->
          $scope.top_influencers = top_influencers
          $scope.$safeApply()
        )
        @founding_donors(school.initiative_id).success((founding_donors)->
          founding_donors.push({}) for founding_donor in [founding_donors.length...5] if founding_donors.length > 0 and founding_donors.length < 5
          $scope.founding_donors = founding_donors
          $scope.$safeApply()
        )
      )
    )
  )
)
