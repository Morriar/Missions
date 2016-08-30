# Test program to run some headless scenarios on the pep missions
#
# TODO: use nitunit to check the result
module test_pep

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
	var i = 0
	for source in [
"""
""",
"""
DECI n,d
LDA n,d
ADDA 10,i
STA n,d
DECO n,d
STOP
n: .BLOCK 2
.END
""",
"""
DECO 10,i
.END
""",
"""
DECI 0,d
LDA 0,d
ADDA 10,i
STA 0,d
DECO 0,d
STOP
.END
"""
] do
		print "## Try source {i} ##"
		var prog = new Program(player, mission, source)
		var runner = config.engine_map["pep8term"]
		runner.run(prog, config)
		print "** {prog.status} errors={prog.test_errors}/{prog.results.length} size={prog.size_score or else "-"} time={prog.time_score}"
		var msg = prog.compilation_messages
		if msg != "" then print "{msg}"
		for tc, res in prog.results do
			var msg_test = res.error
			if msg_test != null then print "{msg_test}"
		end
		i += 1
	end
end
