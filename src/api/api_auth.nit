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

module api_auth

import api_base

# The common auth router
# Specific auth method can refine the class and plug additional handler
class AuthRouter
	super Router

	var config: AppConfig

	init do
		use("/logout", new Logout)
	end
end

redef class Session
	# The current logged user
	var player: nullable Player = null is writable
end

# Reload session player from db between pages
class SessionRefresh
	super APIHandler

	redef fun all(req, res) do
		super
		var session = req.session
		if session == null then return
		var player = session.player
		if player == null then return
		session.player = config.players.find_by_id(player.id)
	end
end

class Logout
	super Handler
	redef fun get(req, res) do
		var session = req.session
		if session == null then return
		session.player = null
		res.redirect "/"
	end
end

class AuthHandler
	super APIHandler

	fun get_player(req: HttpRequest, res: HttpResponse): nullable Player do
		var session = req.session
		if session == null then
			res.error 403
			return null
		end
		var player = session.player
		if player == null then
			res.error 403
			return null
		end
		return player
	end
end

# First login achievement
#
# Unlocked when the player login for the first time ever.
class FirstLoginAchievement
	super Achievement
	serialize
	autoinit player

	redef var key = "first_login"
	redef var title = "Hello World!"
	redef var desc = "Login into the mission board for the first time."
	redef var reward = 10
	redef var icon = "log-in"
end
