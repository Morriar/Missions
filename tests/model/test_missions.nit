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

module test_missions is test_suite

import test_base

class MissionsTest
	super TestBase

	fun test_track_missions do
		var t1 = new_track("t1")
		var t2 = new_track("t2")

		var m1 = new_mission(t1, "m1")
		var m2 = new_mission(t1, "m2")
		var m3 = new_mission(t2, "m3")

		assert t1.missions(config).has_all([m1, m2])
		assert t2.missions(config).has_all([m3])
	end

	fun test_mission_parents do
		var t1 = new_track("t3")

		var m1 = new_mission(t1, "m4")
		var m2 = new_mission(t1, "m5")
		var m3 = new_mission(t1, "m6")

		m2.parents.add m1.id
		m3.parents.add m1.id
		m3.parents.add m2.id

		assert m1.load_parents(config).is_empty
		assert m2.load_parents(config).has_all([m1])
		assert m3.load_parents(config).has_all([m1, m2])
	end

	fun test_mission_children do
		var t1 = new_track("t4")

		var m1 = new_mission(t1, "m7")
		var m2 = new_mission(t1, "m8")
		var m3 = new_mission(t1, "m9")

		m2.parents.add m1.id
		m3.parents.add m1.id
		m3.parents.add m2.id

		config.missions.save m2
		config.missions.save m3

		assert m1.load_children(config).has_all([m2, m3])
		assert m2.load_children(config).has_all([m3])
		assert m3.load_children(config).is_empty
	end

end

redef fun after_module do super
