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
			$scope.playerUrl = '/players/' + $scope.playerId;
			$scope.trackId = $routeParams.tid;
			$scope.missionId = $routeParams.mid;
		}])

		.controller('PlayerAuth', ['$routeParams', '$rootScope', '$scope', function($routeParams, $rootScope, $scope) {

			$scope.playerId = $rootScope.session._id;
			$scope.playerUrl = '/player';
			$scope.trackId = $routeParams.tid;
			$scope.missionId = $routeParams.mid;
			$scope.notifId = $routeParams.nid;
		}])

		.factory('Errors', ['$rootScope', function($rootScope) {
			return {
				handleError: function(err) {
					console.log(err);
				}
			}
		}])

		.controller('PlayersCtrl', ['Errors', 'Players', function(Errors, Players) {
			$controller = this;

			this.loadPlayers = function() {
				Players.getPlayers(
					function(data) {
						$controller.players = data;
					}, Errors.handleError);
			};
		}])

		.controller('PlayerCtrl', ['Errors', 'Players', function(Errors, Players) {
			$controller = this;

			this.loadPlayer = function(playerId) {
				Players.getPlayer(playerId,
					function(data) {
						$controller.player = data;
					}, Errors.handleError);
			};

			this.loadStats = function(playerId) {
				Players.getStats(playerId,
					function(data) {
						$controller.stats = data;
					}, Errors.handleError);
			};

			this.loadTracksStatus = function(playerId) {
				Players.getTracksStatus(playerId,
					function(data) {
						$controller.tracksStatus = data;
					}, Errors.handleError);
			};

			this.loadTrackStatus = function(playerId, trackId) {
				Players.getTrackStatus(playerId, trackId,
					function(data) {
						$controller.trackStatus = data;
					}, Errors.handleError);
			};

			this.loadMissionStatus = function(playerId, missionId) {
				Players.getMissionStatus(playerId, missionId,
					function(data) {
						$controller.missionStatus = data;
					}, Errors.handleError);
			};
		}])

		.controller('AuthCtrl', ['Players', '$rootScope', '$location', function(Players, $rootScope, $location) {

			this.loadSession = function() {
				Players.getAuth(
					function(data) {
						$rootScope.session = data;
					}, function(err) {});
			};
		}])

		.controller('SidebarCtrl', ['Errors', 'Players', function(Errors, Players) {
			$sidebarCtrl = this;

			this.loadStats = function() {
				Players.getStats(this.playerId,
					function(data) {
						$sidebarCtrl.stats = data;
					}, Errors.handleError);
			};

			this.loadFriends = function() {
				Players.getFriends(this.playerId,
					function(data) {
						$sidebarCtrl.friends = data;
					}, Errors.handleError);
			};

			this.removeFriend = function(friendId) {
				Players.removeFriend(friendId,
					function(data) {
						$sidebarCtrl.loadFriends();
					}, Errors.handleError);
			};

			this.hasFriend = function() {
				return this.session.friends.__items.indexOf(this.playerId) >= 0
			};

			this.loadStats();
			this.loadFriends();
		}])

		.controller('FriendsCtrl', ['Errors', 'Players', '$scope', function(Errors, Players, $scope) {
			$friendsCtrl = this;

			this.askFriend = function() {
				if(this.asked) return;
				$friendsCtrl.asked = true;
				Players.askFriend(this.targetId,
					function(data) {
					}, Errors.handleError);
			};
		}])

		.directive('playersList', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/list.html',
				scope: { players: '=' }
			};
		}])

		.directive('playersPodium', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/podium.html',
				scope: { players: '=' }
			};
		}])

		.directive('playerLink', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/link.html',
				scope: { player: '=', noavatar: '=' }
			};
		}])

		.directive('playerMenu', ['$rootScope', function($rootScope) {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/menu.html',
				scope: { player: '=' }
			};
		}])

		.directive('playerSidebar', [function() {
			return {
				scope: {},
				bindToController: {
					session: '=',
					playerId: '='
				},
				controller: 'SidebarCtrl',
				controllerAs: 'sidebarCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/sidebar.html',
				scope: { session: '=', stats: '=' }
			};
		}])

		.directive('playerTracks', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/tracks.html',
				scope: { playerUrl: '=', tracksStatus: '=' }
			};
		}])

		.directive('playerTrack', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/track.html',
				scope: { playerUrl: '=', trackStatus: '=' },
				controller: function ($scope) {
					$scope.hasStar = function(star, stars) {
						for(var i = 0; i < stars.__items.length; i++) {
							var s = stars.__items[i]
							if(s._id == star._id) return true;
						}
						return false;
					};
				}
			};
		}])

		.directive('friendBtn', [function() {
			return {
				scope: {},
				bindToController: {
					session: '=',
					targetId: '='
				},
				controller: 'FriendsCtrl',
				controllerAs: 'friendsCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/friend-btn.html',
			};
		}])

		.directive('trackTree', [function() {
			return {
				replace: true,
				restrict: 'E',
				scope: {
					missionsStatus: '='
				},
				templateUrl: '/directives/track-tree.html',
				link: function ($scope, element, attrs) {
					$scope.buildMap = function(missionsStatus) {
						var map = {};
						missionsStatus.forEach(function(status) {
							map[status.mission._id] = status;
						});
						return map;
					}
					$scope.drawTree = function(missionsStatus) {
						var svg = d3.select(element[0])
						var inner = svg.select("g")
						var render = new dagreD3.render();

						// Left-to-right layout
						var g = new dagreD3.graphlib.Graph()
							.setGraph({
								nodesep: 20,
								ranksep: 50,
								rankdir: "LR",
								marginx: 10,
								marginy: 10
							})
						  .setDefaultEdgeLabel(function() { return {}; });

						function draw(isUpdate) {
							var map = $scope.buildMap(missionsStatus);
							missionsStatus.forEach(function(status, index) {
								g.setNode(status.mission._id, {
									labelType: "html",
									label: "<p class='number'>" + (index + 1) + "</p>",
									rx: 5,
									ry: 5,
									padding: 0,
									id: status.mission._id,
									class: status.status
								});
								status.mission.parents.__items.forEach(function(parent) {
									g.setEdge(parent, status.mission._id, {
										class: map[parent].status
									});
								});
							});

							var hasStar = function(star, stars) {
								for(var i = 0; i < stars.__items.length; i++) {
									var s = stars.__items[i]
									if(s._id == star._id) return true;
								}
								return false;
							}

							render(inner, g);

							$("svg .node").tipsy({
								gravity: $.fn.tipsy.autoNS,
								fade: true,
								html: true,
								title: function() {
									var status = map[this.id];
									var html = ''
									html += "<div class='mission-tip " + status.status + "'>" +
												"<h3>" + status.mission.title + "</h3>" +
												"<p>" + status.mission.reward + " pts</p>"
									for(var i in status.mission.stars.__items) {
										var star = status.mission.stars.__items[i];
										if(hasStar(star, status.stars)) {
											html += "<span class='glyphicon glyphicon-star' />";
										} else {
											html += "<span class='glyphicon glyphicon-star-empty' />";
										}
									}
									html += "</div>"
									return html;
								}
							});
							$("svg .node").click(function() {
								var status = map[this.id];
								window.location.href = "/players/" + status.player._id + "/missions/" + this.id;
							});

							// Zoom and scale to fit
							var graphWidth = g.graph().width;
							var graphHeight = g.graph().height;
							var width = parseInt(svg.style("width").replace(/px/, ""));
							var height = parseInt(svg.style("height").replace(/px/, ""));
							var zoomScale = Math.min(width / graphWidth, height / graphHeight);
							var translate = [(width/2) - ((graphWidth*zoomScale)/2), (height/2) - ((graphHeight*zoomScale)/2)];

							var zoom = d3.behavior.zoom().on("zoom", function() {
								inner.attr("transform", "translate(" + d3.event.translate + ")" +
									"scale(" + d3.event.scale + ")");
							});
							zoom.translate(translate);
							zoom.scale(zoomScale);
							zoom.event(isUpdate ? svg.transition().duration(500) : d3.select("svg"));
						}
						draw();
					}

					$scope.$watch('missionsStatus', function(missionsStatus) {
						if(!missionsStatus) { return; }
						$scope.drawTree(missionsStatus);
					})
				}
			};
		}])
})();
