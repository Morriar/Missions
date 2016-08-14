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
		.module('notifications', ['ngSanitize', 'model'])

		.controller('NotifsCtrl', ['Errors', 'Players', '$rootScope', '$scope', function(Errors, Players, $rootScope, $scope) {
			$notifsCtrl = this;

			this.loadNotifications = function() {
				Players.getNotifications(
					function(data) {
						$rootScope.notifications = data;
					}, Errors.handleError);
			};

			this.clearNotifications = function() {
				Players.deleteNotifications(
					function(data) {
						$rootScope.notifications = data;
					}, Errors.handleError);
			};

			this.loadNotification = function(notifId) {
				Players.getNotification(notifId,
					function(data) {
						$notifsCtrl.notification = data;
					}, Errors.handleError);
			};

			this.clearNotification = function(notifId) {
				Players.deleteNotification(notifId,
					function(data) {
						$scope.notification = data;
						$notifsCtrl.loadNotifications();
					}, Errors.handleError);
			};

			this.acceptFriendRequest = function(notifId, frId) {
				Players.acceptFriendRequest(frId,
					function(data) {
						$notifsCtrl.clearNotification(notifId);
					}, Errors.handleError);
			};

			this.declineFriendRequest = function(notifId, frId) {
				Players.declineFriendRequest(frId,
					function(data) {
						$notifsCtrl.clearNotification(notifId);
					}, Errors.handleError);
			};
		}])

		.directive('notificationsMenu', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/notification/menu.html',
				controller: 'NotifsCtrl',
				controllerAs: 'notifsCtrl'
			};
		}])

		.directive('notification', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/notification/notification.html',
				controller: 'NotifsCtrl',
				controllerAs: 'notifsCtrl',
				scope: { notification: '=' }
			};
		}])
})();
