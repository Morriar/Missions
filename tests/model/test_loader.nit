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

module test_loader is test

import test_base
import model::loader

class LoaderTest
	super TestBase
	test

	var loader: Loader is lazy do return new Loader(config)

	fun test_load_tracks is test do
		loader.load_tracks("tests/test_tracks/")
		assert config.tracks.find_all.length == 2
	end

	fun test_load_track1 is test do
		loader.load_track("tests/test_tracks/track1")
		var track = config.tracks.find_by_id("Track_1").as(not null)
		assert track.title == "Track 1"
		assert track.desc.trim == "<h1 id=\"Track_1\">Track 1</h1>"
		assert track.default_reward == 1
		assert track.default_languages == ["language1"]
		assert track.default_template.trim == "-- template track 1"
		assert track.missions(config).length == 3
	end

	fun test_load_track2 is test do
		loader.load_track("tests/test_tracks/track2")
		var track = config.tracks.find_by_id("Track_2").as(not null)
		assert track.title == "Track 2"
		assert track.desc.trim == "<h1 id=\"Track_2\">Track 2</h1>"
		assert track.default_reward == 0
		assert track.default_languages == new Array[String]
		assert track.default_template == null
	end


	fun test_load_mission1 is test do
		var m = loader.load_mission("tests/test_tracks/track1/mission1", null)
		config.missions.save m
		var mission = config.missions.find_by_id("Mission_1").as(not null)
		assert mission.title == "Mission 1"
		assert mission.desc.trim == "<h2 id=\"Mission_1\">Mission 1</h2>"
		assert mission.reward == 100
		assert mission.languages == ["language_mission1"]
		assert mission.template.trim == "-- template mission 1"
		assert mission.testsuite.length == 3
	end

	fun test_load_mission2 is test do
		loader.load_track("tests/test_tracks/track1")
		var mission = config.missions.find_by_id("Mission_1").as(not null)
		assert mission.title == "Mission 1"
		assert mission.desc.trim == "<h2 id=\"Mission_1\">Mission 1</h2>"
		assert mission.reward == 100
		assert mission.languages == ["language_mission1"]
		assert mission.template.trim == "-- template mission 1"
		assert mission.testsuite.length == 3
	end

	fun test_load_mission3 is test do
		var m = loader.load_mission("tests/test_tracks/track2/mission2", null)
		config.missions.save m
		var mission = config.missions.find_by_id("Mission_2").as(not null)
		assert mission.title == "Mission 2"
		assert mission.desc.trim == "<h2 id=\"Mission_2\">Mission 2</h2>"
		assert mission.reward == 0
		assert mission.languages == new Array[String]
		assert mission.template == null
		assert mission.testsuite.length == 1
	end

	fun test_load_mission4 is test do
		loader.load_track("tests/test_tracks/track2")
		var mission = config.missions.find_by_id("Track_1:Mission_2").as(not null)
		assert mission.title == "Mission 2"
		assert mission.desc.trim == "<h2 id=\"Mission_2\">Mission 2</h2>"
		assert mission.reward == 1
		assert mission.languages == ["language1"]
		assert mission.template.trim == "-- template track 1"
		assert mission.testsuite.length == 1
	end
end

redef fun after_module do super
