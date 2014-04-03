cdoj
.directive("problem",
->
  restrict: "E"
  replace: true
  transclude: true
  scope:
    problem: "="
  link: ($scope) ->
    $scope.$watch("problem",
    ->
      _sampleInput = $scope.problem.sampleInput
      try
        _sampleInput = JSON.parse _sampleInput

      if _sampleInput not instanceof Array
        _sampleInput = [_sampleInput]

      _sampleOutput = $scope.problem.sampleOutput
      try
        _sampleOutput = JSON.parse _sampleOutput

      if _sampleOutput not instanceof Array
        _sampleOutput = [_sampleOutput]

      if _sampleInput.length != _sampleOutput.length
        alert "Sample input has not same number of cases with sample output!"
      else
        $scope.samples = _.map(
          _.zip(_sampleInput, _sampleOutput)
          (sample) ->
            input: sample[0].toString()
            output: sample[1].toString()
        )
    , true)
  templateUrl: "template/problem/problem.html"
)