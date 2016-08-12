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
			if mission_status.is_closed then status.missions_closed += 1
			status.missions.add mission_status
		end

		return status
	end

	fun mission_status(config: AppConfig, mission: Mission): MissionStatus do
		var status = config.missions_status.find_by_mission_and_player(mission, self)
		if status != null then return status
		return new MissionStatus(mission, self, mission.track, "locked")
	end
end

class TrackStatus
	super Jsonable
	serialize

	var id: String is lazy do return "{track.id}-{player.id}"

	var player: Player
	var track: Track

	var missions = new Array[MissionStatus]

	var missions_count: Int = 0
	var missions_locked: Int = 0
	var missions_open: Int = 0
	var missions_closed: Int = 0

	redef fun to_s do return id
	redef fun ==(o) do return o isa SELF and id == o.id
	redef fun hash do return id.hash
	redef fun to_json do return serialize_to_json
end

# The link between a Player and a Mission
class MissionStatus
	serialize
	super Jsonable

	var id: String is lazy, serialize_as "_id" do return "{mission.id}-{player.id}"

	var mission: Mission
	var player: Player
	var track: nullable Track

	# `mission` status for `player`
	#
	# Can be one of:
	# * `locked`: the mission cannot be played
	# * `open`: the mission can be played
	# * `closed`: the mission is a success
	#
	# If no status exists for a couple Mission & Player, one should assume
	# that the mission is locked and check the parents dependencies.
	var status: String

	var is_locked: Bool is lazy, serialize_as "is_locked" do return status == "locked"
	var is_open: Bool is lazy, serialize_as "is_open" do return status == "open"
	var is_closed: Bool is lazy, serialize_as "is_closed" do return status == "closed"

	redef fun to_s do return id
	redef fun ==(o) do return o isa SELF and id == o.id
	redef fun hash do return id.hash
	redef fun to_json do return serialize_to_json
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
