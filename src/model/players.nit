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

module players

import model::model_base

redef class AppConfig
	var players = new PlayerRepo(db.collection("players")) is lazy
end

# Player representation
class Player
	super Entity
	serialize
	autoinit id, name, email, avatar_url

	redef var id

	# The screen name
	var name: nullable String is writable

	# The email
	var email: nullable String is writable

	# The image to use as avatar
	var avatar_url: nullable String is writable
end

class PlayerRepo
	super MongoRepository[Player]
end
