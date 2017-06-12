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

module api_base

import model
import config
import popcorn
import popcorn::pop_json

abstract class APIHandler
	super Handler

	var config: AppConfig
end

class APIRouter
	super Router

	var config: AppConfig
end

abstract class PlayerHandler
	super APIHandler

	fun get_player(req: HttpRequest, res: HttpResponse): nullable Player do
		var pid = req.param("login")
		if pid == null then
			res.api_error("Missing URI param `login`", 400)
			return null
		end
		var player = config.players.find_by_id(pid)
		if player == null then
			res.api_error("Player `{pid}` not found", 404)
			return null
		end
		return player
	end
end

abstract class TrackHandler
	super APIHandler

	fun get_track(req: HttpRequest, res: HttpResponse): nullable Track do
		var tid = req.param("tid")
		if tid == null then
			res.api_error("Missing URI param `tid`", 400)
			return null
		end
		var track = config.tracks.find_by_id(tid)
		if track == null then
			res.api_error("Track `{tid}` not found", 404)
			return null
		end
		return track
	end
end

abstract class MissionHandler
	super APIHandler

	fun get_mission(req: HttpRequest, res: HttpResponse): nullable Mission do
		var mid = req.param("mid")
		if mid == null then
			res.api_error("Missing URI param `mid`", 400)
			return null
		end
		var mission = config.missions.find_by_id(mid)
		if mission == null then
			res.api_error("Mission `{mid}` not found", 404)
			return null
		end
		return mission
	end
end

redef class HttpResponse

	# Return a JSON error
	#
	# Format:
	# ~~~json
	# { message: "Not found", status: 404 }
	# ~~~
	fun api_error(message: String, status: Int) do
		json_error(message, status)
	end
end
