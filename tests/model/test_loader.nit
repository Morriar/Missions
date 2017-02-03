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

module test_loader is test_suite

import test_base
import model::loader

class LoaderTest
	super TestBase

	fun test_load_tracks do
		config.load_tracks("tracks/")
		assert config.tracks.find_all.length == 3
	end

	fun test_load_track do
		config.load_track("tracks/pep8")
		var track = config.tracks.find_by_id("Pep8").as(not null)
		assert track.title == "Pep8"
		assert track.missions(config).length == 11
	end

	fun test_load_mission do
		config.load_track("tracks/pep8")
		var mission = config.missions.find_by_id("Pep8:Addition_simple").as(not null)
		assert mission.title == "Addition simple"
		assert mission.testsuite.length == 4
	end
end

redef fun after_module do super
