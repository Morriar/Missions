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
	angular.module('ng-app', ['ui.router', 'ngSanitize', 'angular-loading-bar', 'tracks', 'missions', 'submission', 'players', 'notifications', 'friends', 'achievements'])

	.config(['cfpLoadingBarProvider', function(cfpLoadingBarProvider) {
		cfpLoadingBarProvider.includeSpinner = false;
	}])

	.config(function ($stateProvider, $locationProvider) {
		$locationProvider.html5Mode(true);
		$stateProvider
			.state({
				name: "home",
				url: "/",
				templateUrl: "/views/index.html",
			})
			.state({
				name: "login",
				url: "",
				controller: function () {
					window.location.replace('/auth/login');
				},
				template: "<div></div>"
			})
			.state({
				name: "logout",
				url: "/auth/logout",
				controller: function () {
					window.location.replace('/auth/logout');
				},
				template: "<div></div>"
			})
			.state({
				name: "track",
				url: "/track/{tid}",
				templateUrl: "/views/track.html",
				controller: "TrackHome",
				controllerAs: "vm"
			})
			.state({
				name: "track.mission",
				url: "/{mid}",
				views: {
					"@": {
						templateUrl: '/views/mission.html',
						controller: 'MissionHome'
					}
				}
			})
			.state({
				name: "player",
				url: "/players/{login}",
				templateUrl: 'views/player.html',
				controller : 'PlayerHome',
				controllerAs: "vm"
			})
			.state({
				name: "otherwise",
				url: "*path",
				template: "<panel404 />"
			})
	})

	.directive('panel404', function() {
		return {
			scope: {},
			templateUrl: '/directives/404-panel.html',
			restrict: 'E',
			replace: true
		};
	})

	.directive('breadcrumbs', function() {
		return {
			templateUrl: '/directives/breadcrumbs.html',
			restrict: 'E',
			replace: true
		};
	});
})();
