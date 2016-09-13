# Run each solution to check if it pass the tests and to update the star goals.
#
# TODO: distinct solutions for each star
#
# Solutions are not committed to not spoil the fun!
module setup_pep

import model
import model::loader
import submissions
import api

var opts = new AppOptions.from_args(args)
var config = new AppConfig.from_options(opts)

# clean bd
config.db.drop

# Load pep8
config.load_track("tracks/pep8")

# Create a dummy user
var player = new Player("John", "Doe")
config.players.save player

# Run some submission on the missions
for mission in config.missions.find_all do
	print "Mission {mission} {mission.testsuite.length}"
	var path = mission.path
	if path == null then
		print "  no path. skip"
		continue
	end
	
	# Get a potential solution
	var f = (path / "solution.pep").to_path
	var source = f.read_all
	if source == "" then
		print "{f} does not exists or is empty"
		continue
	end

	# Try the solution
	var sub = new Submission(player, mission, source)
	var runner = config.engine_map["pep8term"]
	runner.run(sub, config)
	print "** {sub.status} errors={sub.test_errors}/{sub.results.length} size={sub.size_score or else "-"} time={sub.time_score} in {sub.workspace or else "?"}"
	var msg = sub.compilation_messages
	if msg != "" then print "{msg}"
	for res in sub.results do
		var msg_test = res.error
		if msg_test != null then print "{res.testcase.provided_input} {msg_test}"
	end

	# If success, update the goals in the original .ini file
	if sub.status == "success" then
		var ini = new ConfigTree((path / "config.ini").to_s)
		ini["star.time_goal"] = sub.time_score.to_s
		ini["star.size_goal"] = sub.size_score.to_s
		ini.save
	end
end
