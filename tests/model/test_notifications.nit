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

module test_notifications is test_suite

import test_base

class NotificationsTest
	super TestBase

	fun new_player_notification(player: Player, id: String): PlayerNotification do
		var notif = new PlayerNotification(player, "obj", "desc")
		config.notifications.save notif
		return notif
	end

	fun test_player_notifications do
		var player = new_player("p1")
		player.add_notification(config, new_player_notification(player, "n1"))
		player.add_notification(config, new_player_notification(player, "n2"))
		player.add_notification(config, new_player_notification(player, "n3"))
		var player2 = new_player("p2")
		player2.add_notification(config, new_player_notification(player2, "n4"))
		player2.add_notification(config, new_player_notification(player2, "n5"))

		assert player.notifications(config).length == 3
		assert player2.notifications(config).length == 2
	end

	fun test_player_clear_notifications do
		var player = new_player("p3")
		player.add_notification(config, new_player_notification(player, "n6"))
		player.add_notification(config, new_player_notification(player, "n7"))
		player.add_notification(config, new_player_notification(player, "n8"))
		var player2 = new_player("p4")
		player2.add_notification(config, new_player_notification(player2, "n9"))
		player2.add_notification(config, new_player_notification(player2, "n10"))

		player.clear_notifications(config)
		assert player.notifications(config).length == 0
		assert player2.notifications(config).length == 2
		player2.clear_notifications(config)
		assert player2.notifications(config).length == 0
	end

	fun test_player_clear_notification do
		var player = new_player("p5")
		var n1 = new_player_notification(player, "n11")
		var n2 = new_player_notification(player, "n12")
		var n3 = new_player_notification(player, "n13")
		player.add_notification(config, n1)
		player.add_notification(config, n2)
		player.add_notification(config, n3)

		assert player.notifications(config).length == 3
		player.clear_notification(config, n1)
		assert player.notifications(config).has_all([n2, n3])
		assert player.notifications(config).length == 2
		player.clear_notification(config, n2)
		assert player.notifications(config).has_all([n3])
		assert player.notifications(config).length == 1
		player.clear_notification(config, n3)
		assert player.notifications(config).length == 0
	end
end

redef fun after_module do super
