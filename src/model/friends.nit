# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
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

module friends

import model::notifications

redef class AppConfig
	var friend_requests = new FriendRequestRepo(db.collection("friend_requests"))
end

redef class Player
	serialize

	# Ids of `self` friend.
	var friends = new Array[String]

	# Add a new friend to player
	fun add_friend(config: AppConfig, player: Player) do
		if player.id == id then return
		friends.add player.id
		config.players.save self
	end

	fun remove_friend(config: AppConfig, player: Player) do
		friends.remove player.id
		config.players.save self
	end

	# Is `player` an accepted friend of `self`?
	fun has_friend(player: Player): Bool do
		return friends.has(player.id)
	end

	fun load_friends(config: AppConfig): Array[Player] do
		var res = new Array[Player]
		for fid in friends do
			var friend = config.players.find_by_id(fid)
			if friend == null then continue
			res.add friend
		end
		return res
	end

	# Friend requests received by `self`
	fun received_friend_requests(config: AppConfig): Array[FriendRequest] do
		return config.friend_requests.find_to_player(self)
	end

	# Friend requests sent by `self`
	fun sent_friend_requests(config: AppConfig): Array[FriendRequest] do
		return config.friend_requests.find_from_player(self)
	end

	# Does `self` already have a friend request from `player`?
	fun has_friend_request_from(config: AppConfig, player: Player): Bool do
		return config.friend_requests.find_between(player, self) != null
	end

	# Create a friend request from `self` to `player`
	#
	# Returns the friend request if the request was created.
	# `null` means the player is already a friend or already has a friend request.
	fun ask_friend(config: AppConfig, player: Player): nullable FriendRequest do
		if self == player then return null
		if player.has_friend(self) then return null
		if player.has_friend_request_from(config, self) then return null
		var fr = new FriendRequest(self, player)
		config.friend_requests.save fr
		player.add_notification(config, fr.new_notification)
		return fr
	end

	# Accept a friend request
	#
	# Return `true` is the request has been accepted.
	fun accept_friend_request(config: AppConfig, friend_request: FriendRequest): Bool do
		if friend_request.to.id != id then return false
		if friend_request.from.id == id then return false
		add_friend(config, friend_request.from)
		friend_request.from.add_friend(config, self)
		config.friend_requests.remove_by_id(friend_request.id)
		friend_request.from.add_notification(config, friend_request.accept_notification)
		return true
	end

	# Decline a friend request
	#
	# Return `true` is the request has been declined.
	fun decline_friend_request(config: AppConfig, friend_request: FriendRequest): Bool do
		if friend_request.to.id != id then return false
		config.friend_requests.remove_by_id(friend_request.id)
		return true
	end
end

class FriendRequest
	super Entity
	serialize

	var from: Player
	var to: Player
	var timestamp: Int = get_time

	# Build a new notification based on `self`
	fun new_notification: FriendRequestNotification do
		return new FriendRequestNotification(self)
	end

	# Build a new notification based on `self`
	fun accept_notification: FriendRequestAcceptNotification do
		return new FriendRequestAcceptNotification(self)
	end

	redef fun ==(o) do return o isa SELF and o.id == id
end

class FriendRequestRepo
	super MongoRepository[FriendRequest]

	# Friend request between `player1` and `player2`
	fun find_between(player1, player2: Player): nullable FriendRequest do
		return find((new MongoMatch).eq("from._id", player1.id).eq("to._id", player2.id))
	end

	# Friend requests from `player`
	fun find_from_player(player: Player): Array[FriendRequest] do
		return find_all((new MongoMatch).eq("from._id", player.id))
	end

	# Friend requests to `player`
	fun find_to_player(player: Player): Array[FriendRequest] do
		return find_all((new MongoMatch).eq("to._id", player.id))
	end
end

class FriendRequestNotification
	super PlayerNotification
	serialize
	autoinit(friend_request)

	redef var player is lazy do return friend_request.to

	var friend_request: FriendRequest

	redef var object = "New friend request"
	redef var body = "Someone want to be your friend."
	redef var icon = "user"
end

class FriendRequestAcceptNotification
	super FriendRequestNotification
	serialize

	redef var player is lazy do return friend_request.from

	redef var object = "Accepted friend request"
	redef var body = "Someone accepted your friend request."
end
