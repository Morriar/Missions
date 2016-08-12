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

	# MongoDB server used for data persistence.
	var app_db_host: String is lazy do return value_or_default("app.db.host", "mongodb://localhost:27017/")

	# MongoDB DB used for data persistence.
	var app_db_name: String is lazy do return value_or_default("app.db.name", "missions")

	# Mongo db client
	var client = new MongoClient(app_db_host) is lazy

	# Mongo db instance
	var db: MongoDb = client.database(app_db_name) is lazy

	# Github client id used for Github OAuth login.
	var gh_client_id: String is lazy do return value_or_default("github.client.id", "")

	# Github client secret used for Github OAuth login.
	var gh_client_secret: String is lazy do return value_or_default("github.client.secret", "")
end
