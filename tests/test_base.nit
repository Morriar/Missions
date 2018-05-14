# Copyright 2017 Alexandre Terrasa <alexandre@moz-code.org>.
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

module test_base is test

import config
import model

redef class AppConfig
	var testing_id: String = "NIT_TESTING_ID".environ
	redef var default_db_name = "missions_test_{testing_id}"
end

class TestBase
	test

	var config: AppConfig is lazy do
		var config = new AppConfig
		config.parse_options(new Array[String])
		return config
	end

	fun new_track(id: String): Track do
		var track = new Track(id, "title_{id}", "desc_{id}")
		config.tracks.save track
		return track
	end

	fun new_mission(track: nullable Track, id: String): Mission do
		var mission = new Mission(id, track, "title_{id}", "desc_{id}")
		mission.solve_reward = 10
		config.missions.save mission
		return mission
	end

	fun new_player(id: String): Player do
		var player = new Player(id)
		config.players.save player
		return player
	end
end

fun after_module is after_all do
	var config = new AppConfig
	config.parse_options(new Array[String])
	config.db.drop
end
