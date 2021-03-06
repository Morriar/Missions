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

		.controller('MissionHome', ['$stateParams', '$state', '$rootScope', '$scope', function($stateParams, $state, $rootScope, $scope) {
			if($rootScope.session) {
				$scope.playerId = $rootScope.session._id;
			}

			if($stateParams.mid == "" || !!$stateParams.mid === false) {
				$state.go("^");
			}

			$scope.missionId = $stateParams.mid;
			$scope.mid = $scope.missionId;
		}])

		/* Mission */

		.directive('mission', ['$rootScope', function($rootScope) {
			return {
				scope: {},
				bindToController: {
					playerId: '=',
					missionId: '='
				},
				controller: ['Errors', 'Missions', 'Players', '$scope', function(Errors, Missions, Players, $scope) {
					var $ctrl = this;

					this.getMissionStatus = function () {
						if($ctrl.playerId) {
							Players.getMissionStatus($ctrl.playerId, $ctrl.missionId,
								function(data) { $ctrl.missionStatus = data; }, Errors.handleError);
						}
					};

					$scope.$on('mission_submission', function (data) {
						$ctrl.getMissionStatus();
					});

					Missions.getMission(this.missionId, function(data) {
						$ctrl.mission = data;
							// Set breadcrumbs
							$rootScope.track = data.track;
							$rootScope.mission = data;
							$rootScope.player = null;
					}, function(err) {
						$ctrl.error = err;
					});
					this.getMissionStatus();
				}],
				controllerAs: 'missionCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/mission.html',
			};
		}])

		.directive('missionPanel', [function() {
			return {
				scope: {},
				bindToController: {
					index: '=',
					mission: '=',
					missionStatus: '='
				},
				controller: function () {},
				controllerAs: 'missionCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/mission-panel.html'
			};
		}])

		.directive('missionStatus', [function () {
			return {
				scope: {
					mission: '=',
					missionStatus: '='
				},
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/status.html'
			};
		}])

		.directive('missionBtn', [function () {
			return {
				scope: {
					mission: '=',
					missionStatus: '='
				},
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/button.html'
			};
		}])

		/* Mission stars */

		.directive('missionStars', [function () {
			return {
				scope: {},
				bindToController: {
					mission: '=',
					missionStatus: '='
				},
				controller: function () {},
				controllerAs: 'starsCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/stars.html'
			};
		}])

		.directive('missionStar', [function () {
			return {
				scope: {},
				bindToController: {
					star: '=',
					starStatus: '='
				},
				controller: function () {
					this.isSuccess = function() {
						return this.starStatus && this.starStatus.is_unlocked;
					}
				},
				link: function($scope, $elem) {
					$scope.$watch('starCtrl.star', function(star) {
						$elem.attr('title',  star.title + ' (' + star.reward + ' pts)');
						$elem.tooltip();
					})
				},
				controllerAs: 'starCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/star.html'
			};
		}])

		.directive('starProgress', [function () {
			return {
				scope: {},
				bindToController: {
					star: '=',
					submission: '='
				},
				controller: ['$scope', function ($scope) {
					var vm = this;

					$scope.$watch('progressCtrl.submission', function(submission) {
						if(!submission) return;
						vm.score = submission[vm.star.submission_key];
						vm.goal = vm.star.goal;

						vm.bars = [];

						if(vm.score <= vm.goal) {
							vm.style = "progress-bar-success";
							vm.width = vm.score * 100 / vm.goal;
						} else {
							vm.style = "progress-bar-danger";
							vm.width = (vm.score - vm.goal) * 100 / vm.score;
						}
					})
				}],
				controllerAs: 'progressCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/missions/star-progress.html'
			};
		}])

		/* Events */

		.directive('eventPanel', [function () {
			return {
				scope: {
					event: '='
				},
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/events/event.html'
			};
		}])
})();
