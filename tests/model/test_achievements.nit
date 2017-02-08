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

module test_achievements is test_suite

import test_base

class TestAchievement
	super Achievement
	serialize
end

class AchievementsTest
	super TestBase

	fun new_achievement(player: Player, id: String): TestAchievement do
		return new TestAchievement(id, player, "title_{id}", "desc_{id}", 10, "")
	end

	fun test_player_add_achievement do
		var p1 = new_player("p1")
		var before = p1.notifications(config).length
		var a1 = new_achievement(p1, "a1")
		p1.add_achievement(config, a1)
		var a2 = new_achievement(p1, "a2")
		p1.add_achievement(config, a2)
		var a3 = new_achievement(p1, "a3")
		p1.add_achievement(config, a3)
		var p2 = new_player("p2")
		var a4 = new_achievement(p2, "a4")
		p2.add_achievement(config, a4)
		var a5 = new_achievement(p2, "a5")
		p2.add_achievement(config, a5)
		assert p1.achievements(config).has_all([a1, a2, a3])
		assert p1.notifications(config).length == before + 3
		assert p2.achievements(config).has_all([a4, a5])
	end

	fun test_player_has_achievement do
		var p1 = new_player("p3")
		var a1 = new_achievement(p1, "a6")
		p1.add_achievement(config, a1)
		var p2 = new_player("p4")
		var a2 = new_achievement(p2, "a7")
		p2.add_achievement(config, a2)
		assert p1.has_achievement(config, a1)
		assert not p1.has_achievement(config, a2)
		assert p2.has_achievement(config, a2)
		assert not p2.has_achievement(config, a1)
	end

	fun test_achievement_players do
		var p1 = new_player("p5")
		var a1 = new_achievement(p1, "a8")
		p1.add_achievement(config, a1)
		var p2 = new_player("p6")
		var a2 = new_achievement(p2, "a8")
		p2.add_achievement(config, a2)

		assert a1.players(config).has_all([p1, p2])
		assert a2.players(config).has_all([p1, p2])
	end
end

redef fun after_module do super
