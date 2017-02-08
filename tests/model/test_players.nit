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

module test_players is test_suite

import test_base

class PlayersTest
	super TestBase

	fun test_find_all_1 do
		var player = new_player("id1")
		assert config.players.find_all.has(player)
	end

	fun test_find_all_2 do
		var player1 = new_player("id2")
		var player2 = new_player("id3")
		assert config.players.find_all.has_all([player1, player2])
	end

	fun test_find_one do
		var player = new_player("id4")
		assert config.players.find_by_id(player.id) == player
	end
end

redef fun after_module do super
