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

redef class AppConfig

	# Authentification method used
	#
	# At this point can be either `github` or `shib`, see the clients modules.
	var auth_method: String is lazy do return value_or_default("auth", default_auth_method)

	# Default authentification method used
	#
	# Will be refined based on what auth method we implement.
	fun default_auth_method: String is abstract

	redef init from_options(opts) do
		super
		var auth_method = opts.opt_auth_method.value
		if auth_method != null then self["auth"] = auth_method
	end
end

redef class AppOptions

	# Authentification to use
	#
	# Can be either `github` or `shib`.
	var opt_auth_method = new OptionString("Authentification service to use. Can be `github` (default) or `shib`", "--auth")

	init do
		super
		add_option(opt_auth_method)
	end
end

# The common auth router
# Specific auth method can refine the class and plug additional handler
class AuthRouter
	super Router

	var config: AppConfig

	init do
		use("/auth_method", new AuthMethodHandler(config))
	end
end

redef class Session
	# The current logged user
	var player: nullable Player = null is writable

	# Page to redirect on successful authentication
	var auth_next: nullable String = null is writable
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

# Common services related to authentication/login.
abstract class AuthLogin
	super APIHandler

	# Extract a possible next page from the GET arguments and store it in the session for later
	#
	# Helper method to use before initiating a login attempt.
	fun store_next_page(req: HttpRequest)
	do
		var session = req.session
		if session == null then return

		var next = req.string_arg("next")
		if next != null then next = next.from_percent_encoding
		session.auth_next = next
	end

	# Register a new player and add a first-login achievement
	#
	# Helper method to use when a new account is created.
	fun register_new_player(player: Player)
	do
		player.add_achievement(config, new FirstLoginAchievement(player))
		config.players.save player
	end

	# Redirect to the `next` page.
	#
	# Helper method to use at the end of the login attempt.
	fun redirect_after_login(req: HttpRequest, res: HttpResponse)
	do
		var session = req.session
		if session == null then return

		var next = session.auth_next or else "/player"
		session.auth_next = null
		res.redirect next
	end
end

class AuthHandler
	super APIHandler

	fun get_player(req: HttpRequest, res: HttpResponse): nullable Player do
		var session = req.session
		if session == null then
			res.api_error("Unauthorized", 403)
			return null
		end
		var player = session.player
		if player == null then
			res.api_error("Unauthorized", 403)
			return null
		end
		return player
	end
end

# Return the current authentification handler used.
#
# Could also be used to pass the login/logout uris to the frontend.
# But I'm too lazy.
class AuthMethodHandler
	super APIHandler

	redef fun get(req, res) do
		var obj = new JsonObject
		obj["auth_method"] = config.auth_method
		res.json obj
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
