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
			$scope.mid = $scope.missionId;
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

		.controller('PlayerMissionCtrl', ['Errors', 'Players', function (Errors, Players) {

			var vm = this;

			Players.getMissionStatus(this.playerId, this.missionId, function(data) {
					vm.missionStatus = data;
			}, Errors.handleError);

			vm.statusByStar = function (starId) {
				var unlocked = false;
				angular.forEach(vm.missionStatus.star_status.__items, function (starStatus) {
					if(starId == starStatus.star._id) {
						unlocked = starStatus.is_unlocked;
					}
				});
				return unlocked;
			};

		}])

		.controller('MissionSubmitCtrl', ['Missions', '$scope', function (Missions, $scope) {
			$scope.source = "";
			$scope.lang = "pep8";
			$scope.engine = "pep8term";

			$scope.submit = function () {
				var data = {
					source: $scope.source,
					lang: $scope.lang,
					engine: $scope.engine
				};
				Missions.sendMissionSubmission(data, $scope.missionId, function (data) {
					$scope.source = data;
				}, function () {
					console.log("err");
				});
			};
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
				controller: 'PlayerMissionCtrl',
				controllerAs: 'missionCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/mission.html',
			};
		}])

		.directive('missionSubmit', [function () {
			return {
				transclude: true,
				scope: {
					missionId: '=missionId'
				},
				restrict: 'E',
				templateUrl: '/directives/missions/submit.html'
			};
		}])
})();
