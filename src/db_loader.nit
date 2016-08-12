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

import model

var opts = new AppOptions.from_args(args)
var config = new AppConfig.from_options(opts)

# clean bd
config.tracks.clear
config.missions.clear

# load some tracks and missions
for i in [1..15] do
	var track = new Track("Track {i}", "desc {i}")
	config.tracks.save track
	var last_missions = new Array[Mission]
	for j in [1..15] do
		var mission = new Mission(track, "Mission {i}-{j}", "desc {j}")
		if last_missions.not_empty then
			mission.parents.add last_missions.last.id
		end
		last_missions.add mission
		config.missions.save mission
	end
end

print "Loaded {config.tracks.find_all.length} tracks"
print "Loaded {config.missions.find_all.length} missions"
