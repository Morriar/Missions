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
			$scope.trackId = $routeParams.tid;
			$scope.missionId = $routeParams.mid;
		}])

		.controller('PlayersCtrl', ['Players', '$rootScope', function(Players, $scope) {
			this.loadPlayers = function() {
				Players.getPlayers(
					function(data) {
						$scope.players = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadPlayers();
		}])

		.controller('PlayerCtrl', ['Players', '$scope', function(Players, $scope) {
			this.loadPlayer = function() {
				Players.getPlayer($scope.playerId,
					function(data) {
						$scope.player = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadTracksStatus = function() {
				Players.getTracksStatus($scope.playerId,
					function(data) {
						$scope.tracks_status = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadTrackStatus = function() {
				Players.getTrackStatus($scope.playerId, $scope.trackId,
					function(data) {
						$scope.status = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadMissionStatus = function() {
				Players.getMissionStatus($scope.playerId, $scope.missionId,
					function(data) {
						$scope.mission_status = data;
					}, function(err) {
						$scope.error = err;
					});
			};
		}])

		.controller('AuthCtrl', ['Players', '$rootScope', function(Players, $scope) {
			this.loadPlayer = function() {
				Players.getAuth(
					function(data) {
						$scope.player = data;
					}, function(err) {
						$scope.error = err;
					});
			};

			this.loadPlayer();
		}])

		.directive('playerMenu', ['$rootScope', function($rootScope) {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/menu.html',
				controller: 'AuthCtrl',
				controllerAs: 'playerCtrl'
			};
		}])

		.directive('playerSidebar', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/sidebar.html',
				controller: 'PlayerCtrl',
				controllerAs: 'playerCtrl'
			};
		}])

		.directive('playerTracks', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/tracks.html',
				controller: 'PlayerCtrl',
				controllerAs: 'playerCtrl'
			};
		}])

		.directive('playerTrack', [function() {
			return {
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/player/track.html',
				controller: 'PlayerCtrl',
				controllerAs: 'playerCtrl'
			};
		}])

		.directive('trackTree', [function() {
			return {
				replace: true,
				restrict: 'E',
				scope: {
					missionsStatus: '='
				},
				controller: 'PlayerCtrl',
				controllerAs: 'playerCtrl',
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
								ranksep: 40,
								rankdir: "LR",
								marginx: 10,
								marginy: 10
							})
						  .setDefaultEdgeLabel(function() { return {}; });

						function draw(isUpdate) {
							var map = $scope.buildMap(missionsStatus);
							missionsStatus.forEach(function(status) {
								g.setNode(status.mission._id, {
									labelType: "html",
									label: "<div class=''>" + status.mission.title + "</div>",
									rx: 5,
									ry: 5,
									padding: 0,
									id: status.mission._id,
									class: status.status
								});
								status.mission.parents.__items.forEach(function(parent) {
									g.setEdge(parent, status.mission._id, {
										width: 40,
										class: map[parent].status
									});
								});
							});

							render(inner, g);

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
