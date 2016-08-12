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

module api_missions

import model
import api::api_tracks

redef class APIRouter
	redef init do
		super
		use("/missions", new APIMissions(config))
		use("/missions/:mid", new APIMission(config))
	end
end

class APIMissions
	super APIHandler

	redef fun get(req, res) do
		res.json new JsonArray.from(config.missions.find_all)
	end
end

class APIMission
	super MissionHandler

	redef fun get(req, res) do
		var mission = get_mission(req, res)
		if mission == null then return
		res.json mission
	end
end
