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

module test_tracks is test_suite

import test_base

class TracksTest
	super TestBase

	fun test_find_all_1 do
		var track = new_track("id1")
		assert config.tracks.find_all.has(track)
	end

	fun test_find_all_2 do
		var track1 = new_track("id2")
		var track2 = new_track("id3")
		assert config.tracks.find_all.has_all([track1, track2])
	end

	fun test_find_one do
		var track = new_track("id4")
		assert config.tracks.find_by_id(track.id) == track
	end
end

redef fun after_module do super
