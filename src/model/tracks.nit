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

module tracks

import players

redef class AppConfig
	var tracks = new TrackRepo(db.collection("tracks")) is lazy
end

class Track
	super Entity
	serialize

	redef var id
	var title: String
	var desc: String

	redef fun to_s do return title
end

class TrackRepo
	super MongoRepository[Track]
end
