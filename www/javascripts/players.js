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
	angular
		.module('players', ['ngSanitize', 'model'])

		.controller('PlayerHome', ['$routeParams', '$scope', function($routeParams, $scope) {
			$scope.playerId = $routeParams.login;
			$scope.playerUrl = '/players/' + $scope.playerId;
			$scope.trackId = $routeParams.tid;
			$scope.missionId = $routeParams.mid;
		}])

		.controller('PlayerAuth', ['$routeParams', '$rootScope', '$scope', function($routeParams, $rootScope, $scope) {

			$scope.playerId = $rootScope.session._id;
			$scope.playerUrl = '/player';
			$scope.trackId = $routeParams.tid;
			$scope.missionId = $routeParams.mid;
			$scope.notifId = $routeParams.nid;
		}])

		.factory('Errors', ['$rootScope', function($rootScope) {
			return {
				handleError: function(err) {
					console.log(err);
				}
			}
		}])

		.controller('AuthCtrl', ['Players', '$rootScope', '$location', function(Players, $rootScope, $location) {

			this.loadSession = function() {
				Players.getAuth(
					function(data) {
						$rootScope.session = data;
					}, function(err) {});
			};
		}])

		.directive('playerMenu', ['$rootScope', function($rootScope) {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/menu.html',
				scope: { player: '=' }
			};
		}])

		.controller('SidebarCtrl', ['Errors', 'Players', function(Errors, Players) {
			$sidebarCtrl = this;

			this.loadStats = function() {
				Players.getStats(this.playerId,
					function(data) {
						$sidebarCtrl.stats = data;
					}, Errors.handleError);
			};

			this.hasFriend = function() {
				return this.session.friends.__items.indexOf(this.playerId) >= 0
			};

			this.loadStats();
		}])

		.directive('playerSidebar', [function() {
			return {
				scope: {},
				bindToController: {
					session: '=',
					playerId: '='
				},
				controller: 'SidebarCtrl',
				controllerAs: 'sidebarCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/sidebar.html',
				scope: { session: '=', stats: '=' }
			};
		}])

		.controller('PlayersCtrl', ['Errors', 'Players', function(Errors, Players) {
			$controller = this;

			this.loadPlayers = function() {
				Players.getPlayers(
					function(data) {
						$controller.players = data;
					}, Errors.handleError);
			};
		}])

		.directive('playersList', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/list.html',
				scope: { players: '=' }
			};
		}])

		.directive('playersPodium', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/podium.html',
				scope: { players: '=' }
			};
		}])

		.directive('playerLink', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/link.html',
				scope: { player: '=', noavatar: '=' }
			};
		}])
})();
