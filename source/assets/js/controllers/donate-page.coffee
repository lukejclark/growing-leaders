$http = null

(@DonatePageCtrl = ($scope, _$http)->
  $http = _$http
  $scope.$safeApply = Utils.$safeApply

  matches = document.location.href.match(/donate\/([^\/#]+)/)
  $scope.$root.school_id = $scope.school_id = matches[1] if matches
  $scope.$root.disable_donate_link = true

  $scope.$watch('donation_amount', (donation_amount, old_donation_amount)->
    return if !donation_amount?
    donation_amount = donation_amount.replace(/[^\d\.,]/g, '')
    $scope.donation_amount = '$' + donation_amount
    $('ff-crowdfunder-donate-form .row.amount input').val(donation_amount)
  )

  if $scope.school_id
    fetchSchoolName($scope)
  else
    $scope.is_random_school = true
    fetchRandomSchoolId($scope)

  FF(->
    if !$scope.donation_amount
      $scope.donation_amount = if FF.params.donation_amount then '$'+FF.params.donation_amount.replace('$','') else '$30'
      $scope.$safeApply()
    FF.app('crowdfunder').on('donate', (form_data)->
      FF.app('crowdfunder').register(
        first_name: form_data.first_name
        last_name: form_data.last_name
        email: form_data.email
      )
      $scope.has_donated = true
      $scope.$safeApply()
    )
  )

).$inject = ['$scope','$http']


fetchSchoolName = (($scope)->
  $http.get("//#{DATA_DOMAIN}/schools/#{$scope.school_id}?fields=name").success((school)->
    $scope.school_name = school.name
  ).error((data, status, headers, config)->
    FF.error 'ERROR', data
  )
)

fetchRandomSchoolId = (($scope)->
  $http.get("//#{DATA_DOMAIN}/random_school").success((school)->
    $scope.school_name = school.name
    $scope.school_id = school._id
  ).error((data, status, headers, config)->
    FF.error 'ERROR', data
  )
)