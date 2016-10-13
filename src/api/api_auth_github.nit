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

module api_auth_github

import api_auth
import popcorn::pop_auth

redef class AppConfig
	redef var default_auth_method = "github"
end

redef class AuthRouter
	redef init do
		super
		if config.auth_methods.has("github") then
			use("/github/login", new MissionsGithubLogin(config))
			use("/github/oauth", new MissionsGithubOAuthCallBack(config))
		end
	end
end

class MissionsGithubLogin
	super GithubLogin
	super AuthLogin

	autoinit config

	init do
		client_id = config.gh_client_id
	end

	redef fun get(req, res) do
		store_next_page(req)
		super
	end
end

class MissionsGithubOAuthCallBack
	super GithubOAuthCallBack
	super AuthLogin

	autoinit config

	init do
		client_id = config.gh_client_id
		client_secret = config.gh_client_secret
	end

	redef fun get(req, res) do
		super

		var session = req.session
		if session == null then return
		var user = session.user
		if user == null then return
		var id = user.login
		var player = config.players.find_by_id(id)
		if player == null then
			player = new Player(id)
			player.name = user.login
			player.avatar_url = user.avatar_url
			register_new_player(player)
		end
		session.player = player
		redirect_after_login(req, res)
	end
end

redef class Logout
	redef fun get(req, res) do
		var session = req.session
		if session != null then session.user = null
		super
	end
end
