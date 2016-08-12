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
			$scope.trackId = $routeParams.tid;
			$scope.missionId = $routeParams.mid;
		}])

		.controller('PlayersCtrl', ['Players', '$rootScope', function(Players, $scope) {
			this.loadPlayers = function() {
				Players.getPlayers(
					function(data) {
						$scope.players = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadPlayers();
		}])

		.controller('PlayerCtrl', ['Players', '$scope', function(Players, $scope) {
			this.loadPlayer = function() {
				Players.getPlayer($scope.playerId,
					function(data) {
						$scope.player = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadTracksStatus = function() {
				Players.getTracksStatus($scope.playerId,
					function(data) {
						$scope.tracks_status = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadTrackStatus = function() {
				Players.getTrackStatus($scope.playerId, $scope.trackId,
					function(data) {
						$scope.status = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadMissionStatus = function() {
				Players.getMissionStatus($scope.playerId, $scope.missionId,
					function(data) {
						$scope.mission_status = data;
					}, function(err) {
						$scope.error = err;
					});
			};

		}])

		.directive('playerSidebar', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/sidebar.html',
				controller: 'PlayerCtrl',
				controllerAs: 'playerCtrl'
			};
		}])

		.directive('playerTracks', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/tracks.html',
				controller: 'PlayerCtrl',
				controllerAs: 'playerCtrl'
			};
		}])

		.directive('playerTrack', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/track.html',
				controller: 'PlayerCtrl',
				controllerAs: 'playerCtrl'
			};
		}])
})();
