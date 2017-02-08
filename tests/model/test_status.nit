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

module test_status is test_suite

import test_base

class StatusTest
	super TestBase

	fun test_tracks_status do
		var t1 = new_track("t1")
		var m1 = new_mission(t1, "m1")
		var m2 = new_mission(t1, "m2")
		var m3 = new_mission(t1, "m3")

		var t2 = new_track("t2")
		var m4 = new_mission(t1, "m4")
		var m5 = new_mission(t1, "m5")

		var player = new_player("id1")
		var status = player.tracks_status(config)

		assert status.length == 2
	end

	fun test_track_status do
		var t1 = new_track("t3")
		var m1 = new_mission(t1, "m6")
		var m2 = new_mission(t1, "m7")
		m2.parents.add m1.id
		config.missions.save m2
		var m3 = new_mission(t1, "m8")
		m3.parents.add m2.id
		config.missions.save m3

		var t2 = new_track("t4")
		var m4 = new_mission(t2, "m9")
		var m5 = new_mission(t2, "m10")

		var player = new_player("id2")

		var status1 = player.track_status(config, t1)
		assert status1.missions_count == 3
		assert status1.missions_open == 1
		assert status1.missions_locked == 2
		assert status1.missions_success == 0
		assert status1.stars_count == 0
		assert status1.stars_unlocked == 0

		var status2 = player.track_status(config, t2)
		assert status2.missions_count == 2
		assert status2.missions_open == 2
		assert status2.missions_locked == 0
		assert status2.missions_success == 0
		assert status2.stars_count == 0
		assert status2.stars_unlocked == 0
	end

	fun test_mission_status do
		var t1 = new_track("t3")
		var m1 = new_mission(t1, "m6")
		var m2 = new_mission(t1, "m7")
		m2.parents.add m1.id
		config.missions.save m2
		var m3 = new_mission(t1, "m8")
		m3.parents.add m2.id
		config.missions.save m3

		var player = new_player("id2")

		var status1 = player.mission_status(config, m1)
		assert status1.is_open
		assert not status1.is_locked
		assert not status1.is_success

		var status2 = player.mission_status(config, m2)
		assert not status2.is_open
		assert status2.is_locked
		assert not status2.is_success

		var status3 = player.mission_status(config, m3)
		assert not status3.is_open
		assert status3.is_locked
		assert not status3.is_success

		status1.status = "success"
		config.missions_status.save(status1)

		status1 = player.mission_status(config, m1)
		assert status1.is_open
		assert not status1.is_locked
		assert status1.is_success

		status2 = player.mission_status(config, m2)
		assert status2.is_open
		assert not status2.is_locked
		assert not status2.is_success

		status3 = player.mission_status(config, m3)
		assert not status3.is_open
		assert status3.is_locked
		assert not status3.is_success
	end
end

redef fun after_module do super
