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
config.players.clear
config.notifications.clear
config.tracks.clear
config.missions.clear
config.missions_status.clear

# load some tracks and missions
for i in [1..10] do
	var track = new Track("Track {i}", "desc {i}")
	config.tracks.save track
	var last_missions = new Array[Mission]
	for j in [1..10] do
		var mission = new Mission(track, "Mission {i}-{j}", "desc {j}")
		if last_missions.not_empty then
			if 100.rand > 75 then
				mission.parents.add last_missions.last.id
			else
				mission.parents.add last_missions.rand.id
			end
			if 100.rand > 50 then
				var rand = last_missions.rand.id
				if not mission.parents.has(rand) then mission.parents.add rand
			end
		end
		var stars = [1..3].rand
		for s in [1..stars] do
			mission.add_star(new MissionStar("star{s} explanation", 100.rand))
		end
		last_missions.add mission
		config.missions.save mission
	end
end

# load some players
var aurl = "https://avatars.githubusercontent.com/u/2577044?v=3"
var players = [
	new Player("Morriar", "Morriar", avatar_url= "https://avatars.githubusercontent.com/u/583144?v=3"),
	new Player("privat", "privat", avatar_url= "https://avatars2.githubusercontent.com/u/135828?v=3"),
	new Player("P1", "Player 1", avatar_url=aurl),
	new Player("P2", "Player 2", avatar_url=aurl),
	new Player("P3", "Player 3", avatar_url=aurl),
	new Player("P4", "Player 4", avatar_url=aurl),
	new Player("P5", "Player 5", avatar_url=aurl)
]

for player in players do
	config.players.save player

	# load some statuses
	for mission in config.missions.find_all do
		var status = new MissionStatus(mission, player, mission.track)
		if mission.is_unlocked_for_player(config, player) or 100.rand > 25 then
			status.status = "open"
			for star in mission.stars do
				if 100.rand > 50 then status.stars.add star
			end
		end
		if status.stars.not_empty then status.status = "success"
		config.missions_status.save status
	end

	config.notifications.save new PlayerNotification(player, "Hello {player.id}")
	config.notifications.save new PlayerNotification(player, "Hello2 {player.id}")
end

print "Loaded {config.tracks.find_all.length} tracks"
print "Loaded {config.missions.find_all.length} missions"
print "Loaded {config.players.find_all.length} players"
print "Loaded {config.missions_status.find_all.length} missions status"
