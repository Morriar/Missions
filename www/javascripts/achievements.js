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
		.module('achievements', ['ngSanitize', 'model'])

		.controller('AchsCtrl', ['Errors', 'Achievements', function(Errors, Achievements) {
			$achsCtrl = this;

			this.loadAchievements = function() {
				Achievements.getAchievements(
					function(data) {
						$achCtrl.achievements = data;
					}, Errors.handleError);
			};
		}])

		.controller('AchCtrl', ['Errors', 'Achievements', '$stateParams',
			function(Errors, Achievements, $stateParams) {
			$achCtrl = this;

			this.loadAchievement = function() {
				Achievements.getAchievement(this.achievementId,
					function(data) {
						$achCtrl.achievement = data;
					}, Errors.handleError);
			};

			this.loadAchievementPlayers = function() {
				Achievements.getAchievementPlayers(this.achievementId,
					function(data) {
						$achCtrl.players = data;
					}, Errors.handleError);
			};

			this.achievementId = $stateParams.aid;
			this.loadAchievement();
			this.loadAchievementPlayers();
		}])

		.directive('achievement', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/achievements/achievement.html',
				scope: { achievement: '=' }
			};
		}])

		.directive('achievementsList', [function() {
			return {
				scope: {},
				bindToController: {},
				controller: ['Errors', 'Achievements', function (Errors, Achievements) {
					$achsCtrl = this;
					Achievements.getAchievements(
						function(data) {
							$achsCtrl.achievements = data;
						}, Errors.handleError);
				}],
				controllerAs: 'achievementsCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/achievements/list.html',
			};
		}])

		.directive('playerAchievements', [function() {
			return {
				scope: {},
				bindToController: {
					player: '='
				},
				controller: ['Errors', 'Players', function (Errors, Players) {
					$playerAchsCtrl = this;
					Players.getAchievements(this.player._id,
						function(data) {
							$playerAchsCtrl.achievements = data;
						}, Errors.handleError);
				}],
				controllerAs: 'achievementsCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/achievements/list.html',
			};
		}])
})();
