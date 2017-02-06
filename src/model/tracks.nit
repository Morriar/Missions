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

	# List of default allowed languages
	var default_languages = new Array[String]

	# Default reward for a solved mission
	var default_reward = 0 is writable

	# Default description of a time star
	var default_time_desc = "Instruction CPU" is writable

	# Default reward for a time star
	var default_time_score = 10 is writable

	# Default description of a size star
	var default_size_desc = "Taille du code machine" is writable

	# Default reward for a size star
	var default_size_score = 10 is writable

	# Default template for the source code
	var default_template: nullable String = null is writable

	# Default engine used to check submissions
	var default_engine = "" is writable

	# Default code editor used in frontend
	var default_editor = "" is writable
end

class TrackRepo
	super MongoRepository[Track]
end
