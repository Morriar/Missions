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

module api_tracks

import model
import api::api_players

redef class APIRouter
	redef init do
		super
		use("/tracks", new APITracks(config))
		use("/tracks/:tid", new APITrack(config))
		use("/tracks/:tid/missions", new APITrackMissions(config))
	end
end

class APITracks
	super APIHandler

	redef fun get(req, res) do
		res.json new JsonArray.from(config.tracks.find_all)
	end
end

class APITrack
	super TrackHandler

	redef fun get(req, res) do
		var track = get_track(req, res)
		if track == null then return
		res.json track
	end
end

class APITrackMissions
	super TrackHandler

	redef fun get(req, res) do
		var track = get_track(req, res)
		if track == null then return
		res.json new JsonArray.from(config.missions.find_by_track(track))
	end
end
