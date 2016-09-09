# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module status

import model::missions

redef class AppConfig
	var missions_status = new MissionStatusRepo(db.collection("missions_status")) is lazy
end

redef class Player

	fun tracks_status(config: AppConfig): Array[TrackStatus] do
		var statuses = new Array[TrackStatus]
		for track in config.tracks.find_all do
			statuses.add track_status(config, track)
		end
		return statuses
	end

	fun track_status(config: AppConfig, track: Track): TrackStatus do
		var status = new TrackStatus(self, track)

		var missions = track.missions(config)
		for mission in missions do
			var mission_status = mission_status(config, mission)
			status.missions_count += 1
			if mission_status.is_locked then status.missions_locked += 1
			if mission_status.is_open then status.missions_open += 1
			if mission_status.is_success then status.missions_success += 1
			status.stars_count += mission.stars.length
			status.stars_unlocked += mission_status.unlocked_stars.length
			status.missions.add mission_status
		end

		return status
	end

	fun mission_status(config: AppConfig, mission: Mission): MissionStatus do
		var status = config.missions_status.find_by_mission_and_player(mission, self)
		if status != null then return status
		status = new MissionStatus(mission, self, mission.track)
		if mission.is_unlocked_for_player(config, self) then
			status.status = "open"
		end
		return status
	end
end

redef class Mission

	# Is a mission available for a player depending on the mission parents status
	fun is_unlocked_for_player(config: AppConfig, player: Player): Bool do
		if parents.is_empty then return true
		for parent_id in parents do
			var parent = config.missions.find_by_id(parent_id)
			if parent == null then continue
			var status = player.mission_status(config, parent)
			if not status.is_success then return false
		end
		return true
	end
end

class TrackStatus
	super Entity
	serialize

	var player: Player
	var track: Track

	var missions = new Array[MissionStatus]

	var missions_count: Int = 0
	var missions_locked: Int = 0
	var missions_open: Int = 0
	var missions_success: Int = 0
	var stars_count = 0
	var stars_unlocked = 0
end

# The link between a Player and a Mission
class MissionStatus
	super Entity
	serialize

	var mission: Mission
	var player: Player
	var track: nullable Track

	# Unlocked stars
	fun unlocked_stars: Array[MissionStar] do
		var stars = new Array[MissionStar]
		for status in stars_status do
			if status.is_unlocked then stars.add status.star
		end
		return stars
	end

	# The state of each star
	var stars_status = new Array[StarStatus]

	# `mission` status for `player`
	#
	# Can be one of:
	# * `locked`: the mission cannot be played
	# * `open`: the mission can be played
	# * `success`: the mission is a success
	#
	# If no status exists for a couple Mission & Player, one should assume
	# that the mission is locked and check the parents dependencies.
	var status: String = "locked" is writable

	var is_locked: Bool is lazy do return status == "locked"
	var is_open: Bool is lazy do return status == "open"
	var is_success: Bool is lazy do return status == "success"
end

# The link between a Player and a Star
class StarStatus
	super Entity
	serialize

	# The associated star
	var star: MissionStar

	# Is the star granted?
	var is_unlocked = false is writable, optional

	# The current best score (for ScoreStar)
	var best_score: nullable Int = null is writable
end

class MissionStatusRepo
	super MongoRepository[MissionStatus]

	fun find_by_track_and_player(track: Track, player: Player): Array[MissionStatus] do
		return find_all(
			(new MongoMatch).eq("track._id", track.id).eq("player._id", player.id))
	end

	fun find_by_mission_and_player(mission: Mission, player: Player): nullable MissionStatus do
		return find((new MongoMatch).eq("mission._id", mission.id).eq("player._id", player.id))
	end
end
