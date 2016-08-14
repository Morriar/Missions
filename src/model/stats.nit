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

module stats

import model::status
import model::achievements

redef class AppConfig
	fun players_ranking: Array[PlayerStats] do
		var res = new Array[PlayerStats]
		for player in players.find_all do
			res.add player.stats(self)
		end
		default_comparator.sort(res)
		return res
	end
end

redef class Player

	fun stats(config: AppConfig): PlayerStats do
		var stats = new PlayerStats(self)
		for track_status in tracks_status(config) do
			stats.missions_count += track_status.missions_count
			stats.missions_locked += track_status.missions_locked
			stats.missions_open += track_status.missions_open
			stats.missions_success += track_status.missions_success
			stats.stars_count += track_status.stars_count
			stats.stars_unlocked += track_status.stars_unlocked
			for mission_status in track_status.missions do
				for star in mission_status.stars do
					stats.score += star.reward
				end
			end
		end
		for a in achievements(config) do
			stats.score += a.reward
			stats.achievements += 1
		end
		return stats
	end
end

class PlayerStats
	super Comparable
	super Entity
	serialize

	redef type OTHER: PlayerStats

	var player: Player

	var score = 0
	var achievements = 0
	var missions_count = 0
	var missions_locked = 0
	var missions_open = 0
	var missions_success = 0
	var stars_count = 0
	var stars_unlocked = 0

	redef fun <=>(o) do return o.score <=> score
end
