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
		.module('missions', ['ngSanitize', 'model'])

		.controller('MissionHome', ['$routeParams', '$rootScope', '$scope', function($routeParams, $rootScope, $scope) {
			if($rootScope.session) {
				$scope.playerId = $rootScope.session._id;
			}
			$scope.missionId = $routeParams.mid;
		}])

		.controller('MissionCtrl', ['Missions', function(Missions) {
			$missionCtrl = this;

			this.loadMission = function() {
				Missions.getMission(this.missionId,
					function(data) {
						$missionCtrl.mission = data;
					}, function(err) {});
			};

			this.loadMission();
		}])

		.directive('mission', [function() {
			return {
				scope: {},
				bindToController: {
					missionId: '='
				},
				controller: 'MissionCtrl',
				controllerAs: 'missionCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/mission.html'
			};
		}])

		.directive('playerMission', [function() {
			return {
				scope: {},
				bindToController: {
					playerId: '=',
					missionId: '='
				},
				controller: ['Errors', 'Players', function (Errors, Players) {
					$playerMissionCtrl = this;
					Players.getMissionStatus(this.playerId, this.missionId,
						function(data) {
							$playerMissionCtrl.missionStatus = data;
						}, Errors.handleError);
				}],
				controllerAs: 'missionCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/mission.html',
			};
		}])
})();
