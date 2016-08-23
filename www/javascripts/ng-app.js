/*
 * Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

(function() {
	angular.module('ng-app', ['ngRoute', 'ngSanitize', 'angular-loading-bar', 'tracks', 'missions', 'players', 'notifications', 'friends', 'achievements'])

	.config(['cfpLoadingBarProvider', function(cfpLoadingBarProvider) {
		cfpLoadingBarProvider.includeSpinner = false;
	}])

	.config(function($routeProvider, $locationProvider) {
		$routeProvider
			.when('/', {
				templateUrl: 'views/index.html',
				controller: 'PlayersCtrl'
			})
			.when('/login', {
				controller : function(){
					window.location.replace('/auth/login');
				},
			    template : "<div></div>"
			})
			.when('/shiblogin', {
				controller : function(){
					window.location.replace('/auth/shiblogin');
				},
			    template : "<div></div>"
			})
			.when('/logout', {
				controller : [ '$rootScope', function($rootScope){
					$rootScope.player = null;
					window.location.replace('/auth/logout');
				}],
			    template : "<div></div>"
			})
			.when('/player/', {
				templateUrl: 'views/player.html',
				controller : 'PlayerAuth'
			})
			.when('/player/tracks/:tid', {
				templateUrl: 'views/player/track.html',
				controller : 'PlayerAuth'
			})
			.when('/player/missions/:mid', {
				templateUrl: 'views/player/mission.html',
				controller : 'PlayerAuth'
			})
			.when('/players/:login', {
				templateUrl: 'views/player.html',
				controller : 'PlayerHome'
			})
			.when('/players/:login/tracks/:tid', {
				templateUrl: 'views/player/track.html',
				controller : 'PlayerHome'
			})
			.when('/players/:login/missions/:mid', {
				templateUrl: 'views/player/mission.html',
				controller : 'PlayerHome'
			})
			.when('/achievements/:aid', {
				templateUrl: 'views/achievement.html',
				controller : 'AchCtrl',
				controllerAs : 'achCtrl'
			})
			.when('/tracks/:tid', {
				templateUrl: 'views/track.html',
				controller : 'TrackHome'
			})
			.when('/missions/:mid', {
				templateUrl: 'views/mission.html',
				controller : 'MissionHome'
			})
			.otherwise({
				redirectTo: '/'
			});
		$locationProvider.html5Mode(true);
	});
})();
