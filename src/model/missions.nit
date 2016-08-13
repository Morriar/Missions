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

module missions

import model::tracks
import mongodb::queries

redef class AppConfig
	var missions = new MissionRepo(db.collection("missions")) is lazy
end

redef class Track
	fun missions(config: AppConfig): Array[Mission] do
		return config.missions.find_by_track(self)
	end
end

class Mission
	super Entity
	serialize

	var track: nullable Track
	var title: String
	var desc: String
	var parents = new Array[String]
	var stars = new Array[MissionStar]

	fun add_star(star: MissionStar) do stars.add star

	var reward: Int is lazy do
		var r = 0
		for star in stars do r += star.reward
		return r
	end

	redef fun to_s do return title
end

class MissionRepo
	super MongoRepository[Mission]

	fun find_by_track(track: nullable Track): Array[Mission] do
		if track == null then return find_all
		return find_all((new MongoMatch).eq("track._id", track.id))
	end
end

# Mission requirements
class MissionStar
	super Entity
	serialize

	# The star explanation
	var title: String

	# The reward (in points) accorded when this star is unlocked
	var reward: Int
end
