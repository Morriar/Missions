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

		.controller('PlayerMissionCtrl', ['Errors', 'Players', '$scope', function (Errors, Players, $scope) {

			var vm = this;

			vm.getMissionStatus = function () {
				Players.getMissionStatus(vm.playerId, vm.missionId, function(data) {
					vm.missionStatus = data;
				}, Errors.handleError);
			};

			vm.statusByStar = function (starId) {
				var unlocked = false;
				angular.forEach(vm.missionStatus.star_status.__items, function (starStatus) {
					if(starId == starStatus.star._id) {
						unlocked = starStatus.is_unlocked;
					}
				});
				return unlocked;
			};

			$scope.$on('mission_submission', function (data) {
				vm.getMissionStatus();
			});

			vm.getMissionStatus();

		}])

		.controller('MissionSubmitCtrl', ['Missions', '$scope', function (Missions, $scope) {
			var $ctrl = this;
			$ctrl.source = "; enter your code here\n\n.END";
			$ctrl.lang = "pep8";
			$ctrl.engine = "pep8term";

			$scope.submit = function () {
				var data = {
					source: $ctrl.codeMirror.doc.getValue(),
					lang: $ctrl.lang,
					engine: $ctrl.engine
				};
				Missions.sendMissionSubmission(data, $ctrl.mission._id, function (data) {
					$scope.result = data;
					$scope.$emit('mission_submission', 'success');
				}, function () {
					console.log("err");
				});
			};

			$scope.initCodeMirror = function() {
				$ctrl.codeMirror = CodeMirror.fromTextArea(
					document.getElementById('source'), {
					mode:  "javascript",
					lineNumbers: true,
				});
				$ctrl.codeMirror.doc.setValue($ctrl.source);
			};
		}])

		.directive('testcaseDiff', [function() {
			return {
				scope: {
					diffId: '@',
					diffString: '@'
				},
				restrict: 'E',
				link: function($scope, $element, $attr) {
					$scope.$watch('diffString', function(diffString) {
						var diff2htmlUi = new Diff2HtmlUI({diff: $scope.diffString});
						diff2htmlUi.draw("#" + $scope.diffId, {
							inputFormat: 'json',
							outputFormat: 'side-by-side',
							matching: 'lines',
							synchronisedScroll: true
						});
					});
				},
				templateUrl: '/directives/missions/diff.html'
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
				scope: {},
				bindToController: {
					mission: '='
				},
				controller: 'MissionSubmitCtrl',
				controllerAs: 'missionSubmitCtrl',
				restrict: 'E',
				templateUrl: '/directives/missions/submit.html'
			};
		}])
})();
