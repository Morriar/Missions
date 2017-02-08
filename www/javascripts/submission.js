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
		.module('submission', ['ngSanitize', 'model'])

		.controller('MissionSubmitCtrl', ['Missions', '$scope', function (Missions, $scope) {
			var vm = this;
			if (vm.missionStatus) vm.source = vm.missionStatus.last_submission;
			if (!vm.source) vm.source = vm.mission.template;
			if (!vm.source) vm.source = "";

			$scope.submit = function () {
				var data = {
					source: btoa(vm.codeMirror.doc.getValue())
				};
				Missions.sendMissionSubmission(data, vm.mission._id, function (data) {
					// Only launch fireworks on new success
					if (vm.missionStatus.status !== "success" && data.status === "success") {
						launchFireworks();
					}
					$scope.result = data;
					$scope.$emit('mission_submission', 'success');
				}, function () {
					console.log("Error sending submission data.");
				});
			};

			$scope.initCodeMirror = function() {
				vm.codeMirror = CodeMirror.fromTextArea(
					document.getElementById('source'), {
					mode:  vm.mission.editor,
					lineNumbers: true,
				});
				vm.codeMirror.doc.setValue(vm.source);
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

		.directive('missionSubmit', [function () {
			return {
				transclude: true,
				scope: {},
				bindToController: {
					mission: '=',
					missionStatus: '='
				},
				controller: 'MissionSubmitCtrl',
				controllerAs: 'vm',
				restrict: 'E',
				templateUrl: '/directives/missions/submit.html'
			};
		}])

		.directive('missionLocked', [function () {
			return {
				scope: {},
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/locked.html'
			};
		}])
})();
