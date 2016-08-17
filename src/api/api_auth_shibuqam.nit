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

module api_auth_shibuqam

import api_auth

redef class AuthRouter
	redef init do
		use("/shiblogin", new ShibLogin(config))
		use("/shiblogin/callback", new ShibCallback(config))
	end
end

redef class Session
	# Temporary secret used to avoid cross-site request forgery attacks
	var shib_secret: nullable String = null
end

class ShibLogin
	super APIHandler
	autoinit config

	redef fun get(req, res) do
		var session = req.session
		if session == null then return
		var secret = generate_token
		session.shib_secret = secret
		var redir = config.app_root_url + req.url + "/callback"
		res.redirect "https://info.uqam.ca/oauth?redir={redir.to_percent_encoding}&state={secret.to_percent_encoding}"
	end
end

class ShibCallback
	super APIHandler

	autoinit config

	redef fun get(req, res) do
		var session = req.session
		if session == null then return
		var secret = session.shib_secret
		if secret == null then return
		session.shib_secret = null

		var state = req.string_arg("state")
		if state == null then return
		state = state.from_percent_encoding
		if state != secret then return

		var id = req.string_arg("id")
		if id == null then return
		id = id.from_percent_encoding

		var player = config.players.find_by_id(id)
		if player == null then
			player = new Player(id)
			var name = req.string_arg("name")
			if name != null then name = name.from_percent_encoding
			player.name = name
			var avatar = req.string_arg("avatar")
			if avatar != null then avatar = avatar.from_percent_encoding
			player.avatar_url = avatar
			player.add_achievement(config, new FirstLoginAchievement(player))
			config.players.save player
		end
		session.player = player
		res.redirect "/player"
	end
end
