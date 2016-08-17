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

module api_auth_rand

import api_auth

redef class AuthRouter
	redef init do
		use("/loginas", new RandLogin(config))
	end
end

# Authoritatively set a player (without authentication)
#
# the `id` GET argument is the player id.
# If no such a player exists nothing is done.
# example: http://localhost:3000/auth/loginas?id=Morriar
class RandLogin
	super APIHandler

	autoinit config

	redef fun get(req, res) do
		super
		var session = req.session
		if session == null then return
		var id = req.get_args.get_or_null("id")
		if id == null then return
		var player = config.players.find_by_id(id)
		if player == null then return
		session.player = player
		res.redirect "/player"
	end
end
