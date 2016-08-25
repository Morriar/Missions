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

module achievements

import model::notifications

redef class AppConfig
	var achievements = new AchievementRepo(db.collection("achievements")) is lazy
end

# Achievement representation
#
# Achievement are notorious acts performed by players.
class Achievement
	super Entity
	serialize

	# Timestamp when this achievement god unlocked
	var timestamp: Int = get_time

	# Achievement key used to identify all instances of an achievement
	var key: String

	# Player who unlocked this achievement
	var player: Player

	# Achievement title (should be short and punchy)
	var title: String

	# Achievement description (explains how to get this achievement)
	var desc: String

	# Points rewarded when this achievement is unlocked
	var reward: Int

	# Icon associated to this achievement
	var icon: String

	# List players who unlocked `self`
	fun players(config: AppConfig): Array[Player] do
		var achs = config.achievements.collection.aggregate(
			(new MongoPipeline).
				match((new MongoMatch).eq("key", key)).
				group(new MongoGroup("$player._id")))
		var res = new HashSet[Player]
		for a in achs do
			var player = config.players.find_by_id(a["_id"].as(String))
			if player == null then continue
			res.add player
		end
		return res.to_a
	end
end

redef class Player
	serialize

	# Does `self` already unlocked `achievement`?
	fun has_achievement(config: AppConfig, achievement: Achievement): Bool do
		return config.achievements.player_has_achievement(self, achievement)
	end

	# Lists all achievements unlocked by `self`
	fun achievements(config: AppConfig): Array[Achievement] do
		return config.achievements.find_by_player(self)
	end

	# Unlocks `achievement` for `self`
	#
	# Return false if `self` already unlocked `achievement`
	fun add_achievement(config: AppConfig, achievement: Achievement): Bool do
		if has_achievement(config, achievement) then return false
		config.achievements.save achievement
		add_notification(config, new AchievementUnlockedNotification(achievement))
		return true
	end
end

# Achievements repository
class AchievementRepo
	super MongoRepository[Achievement]

	fun group_achievements: Array[Achievement] do
		var ach_ids = collection.aggregate((new MongoPipeline).group(new MongoGroup("$key")))
		var res = new Array[Achievement]
		for id in ach_ids do
			var a = find_by_key(id["_id"].as(String))
			if a != null then res.add a
		end
		return res
	end

	fun find_by_player(player: Player): Array[Achievement] do
		return find_all((new MongoMatch).eq("player._id", player.id))
	end

	fun player_has_achievement(player: Player, achievement: Achievement): Bool do
		return find((new MongoMatch).
			eq("player._id", player.id).
			eq("key", achievement.key)) != null
	end

	fun find_by_key(key: String): nullable Achievement do
		return find((new MongoMatch).eq("key", key))
	end
end

class AchievementUnlockedNotification
	super PlayerNotification
	serialize
	autoinit(achievement)

	redef var player is lazy do return achievement.player

	var achievement: Achievement

	redef var object = "Achievement unlocked"
	redef var body = "You unlocked a new achievement."
	redef var icon = "check"
end
