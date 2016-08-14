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

		.controller('AuthCtrl', ['Players', '$rootScope', '$location', function(Players, $rootScope, $location) {

			this.loadSession = function() {
				Players.getAuth(
					function(data) {
						$rootScope.session = data;
					}, function(err) {});
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

		.controller('SidebarCtrl', ['Errors', 'Players', function(Errors, Players) {
			$sidebarCtrl = this;

			this.loadStats = function() {
				Players.getStats(this.playerId,
					function(data) {
						$sidebarCtrl.stats = data;
					}, Errors.handleError);
			};

			this.hasFriend = function() {
				return this.session.friends.__items.indexOf(this.playerId) >= 0
			};

			this.loadStats();
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

		.controller('PlayersCtrl', ['Errors', 'Players', function(Errors, Players) {
			$controller = this;

			this.loadPlayers = function() {
				Players.getPlayers(
					function(data) {
						$controller.players = data;
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

		.directive('playerTracks', [function() {
			return {
				scope: {},
				bindToController: {
					playerUrl: '=',
					playerId: '='
				},
				controller: ['Errors', 'Players', function (Errors, Players) {
					$playerTracksCtrl = this;
					Players.getTracksStatus(this.playerId,
						function(data) {
							$playerTracksCtrl.tracksStatus = data;
						}, Errors.handleError);
				}],
				controllerAs: 'tracksCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/tracks.html',
			};
		}])

		.directive('playerTrack', [function() {
			return {
				scope: {},
				bindToController: {
					playerUrl: '=',
					playerId: '=',
					trackId: '='
				},
				controller: ['Errors', 'Players', function (Errors, Players) {
					$playerTrackCtrl = this;
					Players.getTrackStatus(this.playerId, this.trackId,
						function(data) {
							$playerTrackCtrl.trackStatus = data;
						}, Errors.handleError);

					this.hasStar = function(star, stars) {
						for(var i = 0; i < stars.__items.length; i++) {
							var s = stars.__items[i]
							if(s._id == star._id) return true;
						}
						return false;
					};
				}],
				controllerAs: 'trackCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/track.html',
			};
		}])

		.directive('playerMission', [function() {
			return {
				scope: {},
				bindToController: {
					playerUrl: '=',
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
