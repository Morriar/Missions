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
private import curl
private import shibuqam

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
	super AuthLogin

	redef fun get(req, res) do
		store_next_page(req)

		var session = req.session
		if session == null then return
		var secret = generate_token
		session.shib_secret = secret
		var redir = config.app_root_url + req.uri + "/callback"
		var url = "https://info.uqam.ca/oauth/login"
		res.redirect "{url}?redirect_uri={redir.to_percent_encoding}&state={secret.to_percent_encoding}"
	end
end

class ShibCallback
	super AuthLogin

	redef fun get(req, res) do
		# Check if everything matches and get the code
		var session = req.session
		if session == null then return
		var secret = session.shib_secret
		if secret == null then return
		session.shib_secret = null

		var state = req.string_arg("state")
		if state == null then return
		state = state.from_percent_encoding
		if state != secret then return

		var code = req.string_arg("code")
		if code == null then return
		code = code.from_percent_encoding


		# Send the code to the oauth server and get something
		var data = curl_post(code)
		if data == null then return

		# Try to get something an user for the data
		var deser_engine = new JsonDeserializer(data)
		var user = new User.from_deserializer(deser_engine)
		if deser_engine.errors.not_empty then
			print_error "Shibuqam OAuth garbage"
			for e in deser_engine.errors do
				print_error e
			end
			return
		end

		# Get the player (a new or an old one)
		var id = user.id
		var player = config.players.find_by_id(id)
		if player == null then
			player = new Player(id)
			player.name = user.display_name
			player.avatar_url = user.avatar
			register_new_player(player)
		end
		session.player = player
		redirect_after_login(req, res)
	end

	# Send the token, retrieve information
	fun curl_post(code: String): nullable String
	do
		var url = "https://info.uqam.ca/oauth/info"
		var request = new CurlHTTPRequest(url)
		var header = new HeaderMap
		header["accept"] = "application/json"
		request.headers = header
		var post_data = new HeaderMap
		post_data["code"] = code
		request.data = post_data
		var response = request.execute
		if response isa CurlResponseFailed then
			print_error "Shibuqam OAuth failed"
			print_error "Error code: {response.error_code}"
			print_error "Error msg: {response.error_msg}"
			return null
		end
		assert response isa CurlResponseSuccess
		var data = response.body_str
		return data
	end
end
