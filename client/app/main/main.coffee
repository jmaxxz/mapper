'use strict'

angular.module 'mapperApp'
.config ($routeProvider) ->
  $routeProvider
  .when '/',
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
