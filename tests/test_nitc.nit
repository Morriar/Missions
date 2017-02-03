# Test program to run some headless scenarios on the nit missions
#
# TODO: use nitunit to check the result
module test_nitc

import model
import model::loader
import submissions
import api
import debug

var config = new AppConfig
config.parse_options(args)

# clean bd
config.db.drop

# Load nit
config.load_track("tracks/nit")

# Create a dummy user
var player = new Player("John", "Doe")
config.players.save player

# Run some submission on the missions
var mission = config.missions.find_all.first

print "Mission {mission} {mission.testsuite.length}"
var i = 0
for source in [
"""
""",
"""
echo Hello, World!
""",
"""
print "hello world"
""",
"""
class Hello
	fun hi: String do return "Hello, World!"
end
print((new Hello).hi)
""",
"""
print "Hello, World!"
"""
] do
	print "## Try source {i} ##"
	var prog = new Submission(player, mission, source)
	var runner = config.engine_map["nitc"]
	runner.run(prog, config)
	print "** {prog.status} errors={prog.test_errors}/{prog.results.length} size={prog.size_score or else "-"} time={prog.time_score or else "-"}"
	var msg = prog.compilation.message
	if msg != null then print "{msg}"
	for res in prog.results do
		var msg_test = res.error
		if msg_test != null then print "test {res.testcase.number}: {msg_test}"
	end
	for e in prog.star_results do
		print e
	end
	i += 1
end
