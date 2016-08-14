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
		.module('friends', ['ngSanitize', 'model'])

		.controller('FriendsCtrl', ['Errors', 'Players', '$scope', function(Errors, Players, $scope) {
			$friendsCtrl = this;

			this.loadFriends = function() {
				Players.getFriends(this.playerId,
					function(data) {
						$friendsCtrl.friends = data;
					}, Errors.handleError);
			};

			this.removeFriend = function(friendId) {
				Players.removeFriend(friendId,
					function(data) {
						$friendsCtrl.loadFriends();
					}, Errors.handleError);
			};

			this.askFriend = function() {
				if(this.asked) return;
				$friendsCtrl.asked = true;
				Players.askFriend(this.playerId,
					function(data) {
					}, Errors.handleError);
			};
		}])

		.directive('friendsList', [function() {
			return {
				scope: {},
				bindToController: {
					session: '=',
					playerId: '='
				},
				controller: 'FriendsCtrl',
				controllerAs: 'friendsCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/friends/friends-list.html',
			};
		}])

		.directive('friendBtn', [function() {
			return {
				scope: {},
				bindToController: {
					session: '=',
					playerId: '='
				},
				controller: 'FriendsCtrl',
				controllerAs: 'friendsCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/friends/friend-btn.html',
			};
		}])
})();
