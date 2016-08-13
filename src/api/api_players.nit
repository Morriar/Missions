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

module api_players

import model
import api::api_auth

redef class APIRouter
	redef init do
		super
		use("/players", new APIPlayers(config))
		use("/players/:login", new APIPlayer(config))
		use("/players/:login/tracks/", new APIPlayerTracksStatus(config))
		use("/players/:login/tracks/:tid", new APIPlayerTrackStatus(config))
		use("/players/:login/missions/:mid", new APIPlayerMissionStatus(config))
		use("/players/:login/stats/", new APIPlayerStats(config))
		use("/player", new APIPlayerAuth(config))
		use("/player/notifications", new APIPlayerNotifications(config))
		use("/player/notifications/:nid", new APIPlayerNotification(config))
	end
end

class APIPlayers
	super APIHandler

	redef fun get(req, res) do
		res.json new JsonArray.from(config.players_ranking)
	end
end

class APIPlayer
	super PlayerHandler

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		res.json player
	end
end

class APIPlayerAuth
	super AuthHandler

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		res.json player
	end
end

class APIPlayerTracksStatus
	super PlayerHandler

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		res.json new JsonArray.from(player.tracks_status(config))
	end
end

class APIPlayerTrackStatus
	super PlayerHandler
	super TrackHandler

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		var track = get_track(req, res)
		if track == null then return
		res.json player.track_status(config, track)
	end
end

class APIPlayerMissionStatus
	super PlayerHandler
	super MissionHandler

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		var mission = get_mission(req, res)
		if mission == null then return
		res.json config.missions_status.find_by_mission_and_player(mission, player)
	end
end

class APIPlayerStats
	super PlayerHandler

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		res.json player.stats(config)
	end
end

class APIPlayerNotifications
	super AuthHandler

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		res.json new JsonArray.from(player.notifications(config))
	end

	redef fun delete(req, res) do
		var player = get_player(req, res)
		if player == null then return
		player.clear_notifications(config)
		res.json new JsonArray.from(player.notifications(config))
	end
end

class APIPlayerNotification
	super AuthHandler

	fun get_notification(req: HttpRequest, res: HttpResponse): nullable PlayerNotification do
		var nid = req.param("nid")
		if nid == null then
			res.error 400
			return null
		end
		var notif = config.notifications.find_by_id(nid)
		if notif == null then
			res.error 404
			return null
		end
		return notif
	end

	redef fun get(req, res) do
		var player = get_player(req, res)
		if player == null then return
		var notif = get_notification(req, res)
		if notif == null then return
		if player.id != notif.player.id then
			res.error 403
			return
		end
		res.json notif
	end

	redef fun delete(req, res) do
		var player = get_player(req, res)
		if player == null then return
		var notif = get_notification(req, res)
		if notif == null then return
		if player.id != notif.player.id then
			res.error 403
			return
		end
		player.clear_notification(config, notif)
		res.json new JsonObject
	end
end
