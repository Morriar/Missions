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

module api_achievements

import model
import api::api_players

redef class APIRouter
	redef init do
		super
		use("/achievements", new APIAchievements(config))
		use("/achievements/:aid", new APIAchievement(config))
		use("/achievements/:aid/players", new APIAchievementPlayers(config))
	end
end

class APIAchievements
	super APIHandler

	redef fun get(req, res) do
		res.json new JsonArray.from(config.achievements.group_achievements)
	end
end

class APIAchievement
	super APIHandler

	fun get_achievement(req: HttpRequest, res: HttpResponse): nullable Achievement do
		var aid = req.param("aid")
		if aid == null then
			res.api_error("Missing URI param `aid`", 400)
			return null
		end
		var achievement = config.achievements.find_by_key(aid)
		if achievement == null then
			res.api_error("Achievement `{aid}` not found", 404)
			return null
		end
		return achievement
	end

	redef fun get(req, res) do
		var achievement = get_achievement(req, res)
		if achievement == null then return
		res.json achievement
	end
end

class APIAchievementPlayers
	super APIAchievement

	redef fun get(req, res) do
		var achievement = get_achievement(req, res)
		if achievement == null then return
		res.json new JsonArray.from(achievement.players(config))
	end
end
