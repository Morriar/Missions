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

module test_friends is test_suite

import test_base

class FriendsTest
	super TestBase

	fun test_player_add_friend do
		var p1 = new_player("p1")
		var p2 = new_player("p2")
		var p3 = new_player("p3")
		var p4 = new_player("p4")

		p1.add_friend(config, p2)
		p2.add_friend(config, p1)
		p1.add_friend(config, p3)
		p3.add_friend(config, p1)

		assert p1.load_friends(config).has_all([p2, p3])
		assert p2.load_friends(config).has_all([p1])
		assert p3.load_friends(config).has_all([p1])
		assert p4.load_friends(config).is_empty
	end

	fun test_player_remove_friend do
		var p1 = new_player("p5")
		var p2 = new_player("p6")

		p1.add_friend(config, p2)
		assert p1.load_friends(config).has_all([p2])

		p1.remove_friend(config, p2)
		assert p1.load_friends(config).is_empty
	end

	fun test_player_ask_friend do
		var p1 = new_player("p7")
		var p2 = new_player("p8")

		assert not p1.has_friend(p2)
		assert not p2.has_friend(p1)
		p1.ask_friend(config, p2)
		assert not p1.has_friend(p2)
		assert not p2.has_friend(p1)
		assert p2.has_friend_request_from(config, p1)
		assert p2.received_friend_requests(config).length == 1
		assert p2.notifications(config).length == 1
	end

	fun test_player_accept_friend do
		var p1 = new_player("p9")
		var p2 = new_player("p10")

		var req = p1.ask_friend(config, p2)
		p2.accept_friend_request(config, req.as(not null))
		assert not p2.has_friend_request_from(config, p1)
		assert p2.received_friend_requests(config).length == 0
		assert p1.notifications(config).length == 2
		assert p2.notifications(config).length == 2

		assert p1.has_friend(p2)
		assert p2.has_friend(p1)
	end

	fun test_player_decline_friend do
		var p1 = new_player("p11")
		var p2 = new_player("p12")

		var req = p1.ask_friend(config, p2)
		p2.decline_friend_request(config, req.as(not null))
		assert not p2.has_friend_request_from(config, p1)
		assert p2.received_friend_requests(config).length == 0
		assert p1.notifications(config).length == 0
		assert p2.notifications(config).length == 1

		assert not p1.has_friend(p2)
		assert not p2.has_friend(p1)
	end
end

redef fun after_module do super
