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

module config

import popcorn::pop_config
import popcorn::pop_repos

redef class AppConfig

	redef var default_db_name = "missions"

	# --gh-client-id
	var opt_gh_client_id = new OptionString("Github OAuth client id", "--gh-client-id")

	# --gh-client-secret
	var opt_gh_client_secret = new OptionString("Github OAuth client secret", "--gh-client-secret")

	init do
		super
		opts.add_option(opt_gh_client_id, opt_gh_client_secret)
	end

	# Github client id used for Github OAuth login.
	fun gh_client_id: String do
		return opt_gh_client_id.value or else ini["github.client.id"] or else ""
	end

	# Github client secret used for Github OAuth login.
	fun gh_client_secret: String do
		return opt_gh_client_secret.value or else ini["github.client.secret"] or else ""
	end

	# Site root url to use for some redirect
	# Useful if behind some reverse proxy
	fun app_root_url: String do
		var host = app_host
		var port = app_port
		var url = "http://{host}"
		if port != 80 then url += ":{port}"
		return ini["app.root_url"] or else url
	end
end
