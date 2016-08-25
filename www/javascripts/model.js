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
	var apiUrl = '/api';

	angular
		.module('model', [])

		.factory('Players', [ '$http', function($http) {
			return {
				getPlayers: function(cb, cbErr) {
					$http.get(apiUrl + '/players')
						.success(cb)
						.error(cbErr);
				},
				getPlayer: function(login, cb, cbErr) {
					$http.get(apiUrl + '/players/' + login)
						.success(cb)
						.error(cbErr);
				},
				getAuth: function(cb, cbErr) {
					$http.get(apiUrl + '/player')
						.success(cb)
						.error(cbErr);
				},
				getNotifications: function(cb, cbErr) {
					$http.get(apiUrl + '/player/notifications')
						.success(cb)
						.error(cbErr);
				},
				deleteNotifications: function(cb, cbErr) {
					$http.delete(apiUrl + '/player/notifications')
						.success(cb)
						.error(cbErr);
				},
				getNotification: function(nid, cb, cbErr) {
					$http.get(apiUrl + '/player/notifications/' + nid)
						.success(cb)
						.error(cbErr);
				},
				deleteNotification: function(nid, cb, cbErr) {
					$http.delete(apiUrl + '/player/notifications/' + nid)
						.success(cb)
						.error(cbErr);
				},
				getStats: function(login, cb, cbErr) {
					$http.get(apiUrl + '/players/' + login + '/stats')
						.success(cb)
						.error(cbErr);
				},
				getAchievements: function(login, cb, cbErr) {
					$http.get(apiUrl + '/players/' + login + '/achievements')
						.success(cb)
						.error(cbErr);
				},
				getTracksStatus: function(login, cb, cbErr) {
					$http.get(apiUrl + '/players/' + login + '/tracks')
						.success(cb)
						.error(cbErr);
				},
				getTrackStatus: function(login, trackId, cb, cbErr) {
					$http.get(apiUrl + '/players/' + login + '/tracks/' + trackId)
						.success(cb)
						.error(cbErr);
				},
				getMission: function(login, missionId, cb, cbErr) {
					$http.get(apiUrl + '/missions/' + missionId)
						.success(cb)
						.error(cbErr);
				},
				getMissionStatus: function(login, missionId, cb, cbErr) {
					$http.get(apiUrl + '/players/' + login + '/missions/' + missionId)
						.success(cb)
						.error(cbErr);
				},
				askFriend: function(targetId, cb, cbErr) {
					$http.post(apiUrl + '/player/ask_friend/' + targetId)
						.success(cb)
						.error(cbErr);
				},
				acceptFriendRequest: function(fId, cb, cbErr) {
					$http.post(apiUrl + '/player/friend_requests/' + fId)
						.success(cb)
						.error(cbErr);
				},
				declineFriendRequest: function(fId, cb, cbErr) {
					$http.delete(apiUrl + '/player/friend_requests/' + fId)
						.success(cb)
						.error(cbErr);
				},
				getFriends: function(login, cb, cbErr) {
					$http.get(apiUrl + '/players/' + login + '/friends')
						.success(cb)
						.error(cbErr);
				},
				removeFriend: function(fId, cb, cbErr) {
					$http.delete(apiUrl + '/player/friends/' + fId)
						.success(cb)
						.error(cbErr);
				}
			}
		}])
		.factory('Tracks', [ '$http', function($http) {
			return {
				getTrack: function(tid, cb, cbErr) {
					$http.get(apiUrl + '/tracks/' + tid)
						.success(cb)
						.error(cbErr);
				},
				getTrackMissions: function(tid, cb, cbErr) {
					$http.get(apiUrl + '/tracks/' + tid + '/missions')
						.success(cb)
						.error(cbErr);
				}
			}
		}])
		.factory('Missions', [ '$http', function($http) {
			return {
				getMission: function(mid, cb, cbErr) {
					$http.get(apiUrl + '/missions/' + mid)
						.success(cb)
						.error(cbErr);
				},
				sendMissionSubmission: function(data, mid, cb, cbErr) {
					$http.post(apiUrl + '/missions/' + mid, data)
						.success(cb)
						.error(cbErr);
				},
			}
		}])
		.factory('Achievements', [ '$http', function($http) {
			return {
				getAchievements: function(cb, cbErr) {
					$http.get(apiUrl + '/achievements')
						.success(cb)
						.error(cbErr);
				},
				getAchievement: function(aid, cb, cbErr) {
					$http.get(apiUrl + '/achievements/' + aid)
						.success(cb)
						.error(cbErr);
				},
				getAchievementPlayers: function(aid, cb, cbErr) {
					$http.get(apiUrl + '/achievements/' + aid + '/players')
						.success(cb)
						.error(cbErr);
				}
			}
		}])
})();
