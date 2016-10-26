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
		.module('tracks', ['ngSanitize', 'model'])

		.controller('TrackHome', ['$stateParams', '$rootScope', '$scope', function($stateParams, $rootScope, $scope) {
			if($rootScope.session) {
				$scope.playerId = $rootScope.session._id;
			}
			$scope.trackId = $stateParams.tid;
		}])

		.controller('trackListCtrl', ['Errors', 'Tracks', 'Players', function (Errors, Tracks, Players) {
			var vm = this;

			if(vm.playerId) {
				Players.getTracksStatus(vm.playerId, function(data) {
					vm.tracksStatus = data;
				}, Errors.handleError);
			}

			Tracks.getTracks(function(data) {
				vm.tracks = data;
			}, Errors.handleError);

		}])

		.directive('trackList', [function() {
			return {
				scope: {},
				bindToController: {
					playerId: '=' // optional
				},
				controller: 'trackListCtrl',
				controllerAs: 'vm',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/tracks/tracks.html',
			};
		}])

		/* Track */

		.directive('track', ['$rootScope', function($rootScope) {
			return {
				scope: {},
				bindToController: {
					trackId: '=',
					playerId: '=' // optional
				},
				controller: ['Errors', 'Tracks', 'Players', '$stateParams', function (Errors, Tracks, Players, $stateParams) {
					var $ctrl = this;

					if(this.playerId) {
						Players.getTrackStatus(this.playerId, this.trackId,
							function(data) {
								$ctrl.trackStatus = data;
							}, Errors.handleError);
					}

					Tracks.getTrack(this.trackId,
						function(data) {
							$ctrl.track = data;
							// Set breadcrumbs
							$rootScope.track = data;
							$rootScope.mission = null;
							$rootScope.player = null;
						}, function(err) {
							$ctrl.error = err;
						});

					Tracks.getTrackMissions(this.trackId,
						function(data) {
							$ctrl.missions = data;
						}, Errors.handleError);

				}],
				controllerAs: 'trackCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/tracks/track.html',
			};
		}])

		.directive('trackPanel', [function () {
			return {
				scope: {},
				bindToController: {
					track: '=',
					trackStatus: '='
				},
				controller: function () {},
				controllerAs: 'trackCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/tracks/track-panel.html'
			};
		}])

		/* Track progress */

		.directive('missionsProgress', [function () {
			return {
				scope: {},
				bindToController: {
					track: '=',
					trackStatus: '='
				},
				controller: function () {
					this.missions = function() {
						if (this.trackStatus) {
							return this.trackStatus.missions_count;
						}
						return 0;
					}

					this.achieved = function() {
						if (this.trackStatus) {
							return this.trackStatus.missions_success;
						}
						return 0;
					}

					this.progress = function() {
						var missions = this.missions();
						if (missions != 0) {
							return this.achieved() / missions * 100;
						}
						return 0;
					}
				},
				controllerAs: 'barCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/tracks/missions-progress.html'
			};
		}])

		/* Track stars */

		.directive('starsProgress', [function () {
			return {
				scope: {},
				bindToController: {
					track: '=',
					trackStatus: '='
				},
				controller: function () {
					this.stars = function() {
						if (this.trackStatus) {
							return this.trackStatus.stars_count;
						}
						return 0;
					}

					this.unlocked = function() {
						if (this.trackStatus) {
							return this.trackStatus.stars_unlocked;
						}
						return 0;
					}

					this.progress = function() {
						var stars = this.stars();
						if (stars != 0) {
							return this.unlocked() / stars * 100;
						}
						return 0;
					}
				},
				controllerAs: 'barCtrl',
				restrict: 'E',
				replace: true,
				templateUrl: '/directives/tracks/stars-progress.html'
			};
		}])

		/*  Track tree */

		.directive('trackTree', [function() {
			return {
				replace: true,
				restrict: 'E',
				scope: {
					missions: '=',
					missionsStatus: '='
				},
				templateUrl: '/directives/tracks/track-tree.html',
				link: function ($scope, element, attrs) {
					$scope.buildMap = function(missions, missionsStatus) {
						var map = {};
						missions.forEach(function(mission, index) {
							map[mission._id] = mission;
							if(missionsStatus) {
								map[mission._id].status = missionsStatus[index];
							} else {
								map[mission._id].status = { status: 'locked' };
							}
						});
						return map;
					}
					$scope.drawTree = function(missions, missionsStatus) {
						var svg = d3.select(element[0])
						var inner = svg.select("g")
						var render = new dagreD3.render();

						// Left-to-right layout
						var g = new dagreD3.graphlib.Graph()
							.setGraph({
								nodesep: 20,
								ranksep: 50,
								rankdir: "TB",
								marginx: 10,
								marginy: 10
							})
						  .setDefaultEdgeLabel(function() { return {}; });

						function draw(isUpdate) {
							var map = $scope.buildMap(missions, missionsStatus);
							missions.forEach(function(mission, index) {
								g.setNode(mission._id, {
									labelType: "html",
									label: "<p class='number'>" + (index + 1) + "</p>",
									rx: 5,
									ry: 5,
									padding: 0,
									id: mission._id,
									class: mission.status.status
								});
								mission.parents.__items.forEach(function(parent) {
									g.setEdge(parent, mission._id, {
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
									var mission = map[this.id];
									var html = ''
									html += "<div class='mission-tip " + status + "'>" +
												"<h3>" + mission.title + "</h3>" +
												"<p>" + mission.reward + " pts</p>"
									for(var i in mission.stars.__items) {
										var star = mission.stars.__items[i];
										if(hasStar(star, mission.status.stars_status)) {
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
								var trackId;
								var clickedMission = this;
								missions.forEach(function(m) {
									if(m.id === clickedMission.id) {
										trackId = m.track.id;
									}
								});
								window.location.href = "/track/" + trackId + "/" + this.id;
							});

							// Zoom and scale to fit
							var graphWidth = g.graph().width;
							var graphHeight = g.graph().height;
							var width = parseInt(svg.style("width").replace(/px/, ""));
							var height = parseInt(svg.style("height").replace(/px/, ""));
							var graphScale = Math.min(width / graphWidth, height / graphHeight);
							var zoomScale = Math.min(graphScale, 1) - 0.15;
							var translate = [(width/2) - ((graphWidth*zoomScale)/2), 0];
							var zoom = d3.behavior.zoom().on("zoom", function() {
								inner.attr("transform", "translate(" + d3.event.translate + ")" +
									"scale(" + d3.event.scale + ")");
							});
							zoom.translate(translate);
							zoom.scale(zoomScale);
							zoom.event(isUpdate ? svg.transition().duration(500) : d3.select("svg"));
						}
						setTimeout(function() {
							draw();
						}, 100);
					}

					$scope.$watchGroup(['missions', 'missionsStatus'], function(values) {
						if(!values[0]) { return; }
						$scope.drawTree(values[0], values[1]);
					});
				}
			};
		}])
})();
