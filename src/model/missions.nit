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
	serialize
	super Jsonable

	var id: String = (new MongoObjectId).id is serialize_as "_id"
	var track: nullable Track
	var title: String
	var desc: String
	var parents = new Array[String] is serialize_as "parents"

	redef fun to_s do return title
	redef fun ==(o) do return o isa SELF and id == o.id
	redef fun hash do return id.hash
	redef fun to_json do return serialize_to_json
end

class MissionRepo
	super MongoRepository[Mission]

	fun find_by_track(track: nullable Track): Array[Mission] do
		if track == null then return find_all
		return find_all((new MongoMatch).eq("track._id", track.id))
	end
end
