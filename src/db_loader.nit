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
import model::loader
import api

var config = new AppConfig
config.parse_options(args)


# Use level 0 to disable debug things
var level = 1
if args.length >= 1 then level = args[0].to_i

# clean bd
config.players.clear
config.notifications.clear
config.achievements.clear
config.friend_requests.clear
config.tracks.clear
config.missions.clear
config.missions_status.clear

config.load_tracks "tracks"

if level >= 1 then
	config.load_tracks "tracks-wip"

	# load some tracks and missions
	var track_count = 5 * level
	for i in [1..track_count] do
		var track = new Track("track{i}", "Track {i}", "desc {i}")
		config.tracks.save track
		var last_missions = new Array[Mission]
		var mission_count = (10 * level).rand
		for j in [1..mission_count] do
			var mission = new Mission("track{i}:mission{j}", track, "Mission {i}-{j}", "desc {j}")
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
			var star_count = (4 * level).rand
			for s in [1..star_count] do
				mission.add_star(new MissionStar("star{s} explanation", 100.rand))
			end
			last_missions.add mission
			config.missions.save mission
		end
	end

	# load some players
	var morriar = new Player("Morriar", "Morriar", avatar_url= "https://avatars.githubusercontent.com/u/583144?v=3")
	config.players.save morriar
	var privat = new Player("privat", "privat", avatar_url= "https://avatars2.githubusercontent.com/u/135828?v=3")
	config.players.save privat

	# privat.ask_friend(config, morriar)
	privat.add_friend(config, morriar)
	privat.add_achievement(config, new FirstLoginAchievement(privat))
	morriar.add_friend(config, privat)
	morriar.add_achievement(config, new FirstLoginAchievement(morriar))

	var aurl = "https://avatars.githubusercontent.com/u/2577044?v=3"
	var players = new Array[Player]
	players.push morriar
	players.push privat

	var player_count = 30 * level
	for i in [0..player_count] do
		var p = new Player("P{i}", "Player{i}", avatar_url=aurl)
		players.push p
	end

	for player in players do
		config.players.save player

		# load some statuses
		for mission in config.missions.find_all do
			var status = new MissionStatus(mission, player, mission.track)
			if mission.is_unlocked_for_player(config, player) or 100.rand > 25 then
				status.status = "open"
				for star in mission.stars do
					status.stars_status.add new StarStatus(star, 100.rand > 50)
				end
			end
			if status.unlocked_stars.not_empty then status.status = "success"
			config.missions_status.save status
		end

		# Spread some love (or friendships =( )
		for other_player in players do
			if not player.has_friend(other_player) then
				var love = 10.rand
				if love == 1 then player.add_friend(config, other_player)
			end
		end
	end

	config.players.save new Player("John", "Doe")
end

print "Loaded {config.tracks.find_all.length} tracks"
print "Loaded {config.missions.find_all.length} missions"
print "Loaded {config.players.find_all.length} players"
print "Loaded {config.missions_status.find_all.length} missions status"
