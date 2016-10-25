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

		.controller('PlayerHome', ['$stateParams', '$scope', function($stateParams, $scope) {
			$scope.playerId = $stateParams.login;
		}])

		.controller('PlayerAuth', ['$stateParams', '$rootScope', '$scope', function($stateParams, $rootScope, $scope) {

			if($rootScope.session) {
				$scope.playerId = $rootScope.session._id;
			}
			$scope.notifId = $stateParams.nid;

			$rootScope.track = null;
			$rootScope.mission = null;
			$rootScope.player = null;
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

		.directive('player', ['$rootScope', function($rootScope) {
			return {
				scope: {},
				bindToController: {
					session: '=',
					playerId: '='
				},
				controller: ['Errors', 'Players', function(Errors, Players) {
					var vm = this;

					this.loadPlayer = function() {
						Players.getPlayer(vm.playerId,
							function(data) {
								vm.player = data;
								// Set breadcrumbs
								$rootScope.player = data;
							}, function(err) {
								vm.error = err;
							});
					};

					this.loadPlayer();
				}],
				controllerAs: 'vm',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/player.html'
			};
		}])

		.directive('playerMenu', ['Errors', 'Auth', '$rootScope', function(Errors, Auth, $rootScope) {
			return {
				scope: {},
				bindToController: {
					player: '='
				},
				controller: ['$location', function ($location) {
					var vm = this;

					this.login = function(auth) {
						window.location.replace('/auth/' + auth + '/login?next=' + $location.absUrl());
					}

					this.logout = function() {
						$rootScope.player = null;
						window.location.replace('/auth/logout');
					}

					Auth.getAuthMethod(function(data) {
						vm.auth_method = data;
					}, Errors.handleError)
				}],
				controllerAs: 'playerMenuCtrl',
				templateUrl: '/directives/player/menu.html',
				restrict: 'E',
				replace: true
			};
		}])

		.directive('playerSidebar', [function() {
			return {
				scope: {},
				bindToController: {
					session: '=',
					player: '='
				},
				controller: ['Errors', 'Players', function(Errors, Players) {
					var vm = this;

					this.loadStats = function() {
						Players.getStats(this.player._id,
							function(data) {
								vm.stats = data;
							}, Errors.handleError);
					};

					this.hasFriend = function() {
						return this.session.friends.__items.indexOf(this.playerId) >= 0
					};

					this.loadStats();
				}],
				controllerAs: 'sidebarCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/sidebar.html'
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
