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

# Player's submissions for any kind of mission
module submissions

import missions
import players
import status
private import markdown
private import poset

# An entry submitted by a player for a mission.
#
# The last submitted programs and/or the ones that beat stars
# can be saved server-side so that the played can retrieve them.
#
# Other can be discarded (or archived for data analysis and/or the wall of shame)
class Program
	super Jsonable
	serialize

	# The submitter
	var player: Player

	# The attempted mission
	var mission: Mission

	# The submitted source code
	var source: String

	# Individual results for each test case
	#
	# Filled by `check`
	var results = new HashMap[TestCase, TestResult]

	# The status of the submission
	#
	# * `submitted` initially.
	# * `pending` when `check` is called.
	# * `success` compilation and tests are fine.
	# * `error` compilation or tests have issues.
	var status: String = "submitted" is writable

	# The name of the working directory.
	# It is where the source is saved and artifacts are generated.
	var workspace: nullable String = null is writable

	# Object file size in bytes.
	#
	# Use only if status == "success".
	var size_score: nullable Int = null is writable

	# Total execution time.
	#
	# Use only if status == "success".
	var time_score: Int = 0 is writable

	# Compilation messages
	#
	# Is the empty string if no message was produced.
	var compilation_messages: String = "" is writable

	# Has compilation succeeded ?
	var compilation_failed: Bool = false is writable

	# Number of failed test-cases
	var test_errors: Int = 0 is writable

	# Was the run successful?
	fun successful: Bool do return not compilation_failed and test_errors == 0

	# Update status of `self` in DB
	fun update_status(config: AppConfig) do
		var mission_status = config.missions_status.find_by_mission_and_player(mission, player)
		if mission_status == null then
			mission_status = new MissionStatus(mission, player)
		end
		mission_status.status = status

		# Update/unlock stars
		if successful then for star in mission.stars do star.check(self, mission_status)

		config.missions_status.save(mission_status)
	end

	redef fun to_json do return serialize_to_json
end

# This model provides easy deserialization of posted submissions
class Submission
	serialize

	# Source code to be run
	var source: String
	# Engine or runner to be used
	var engine: String
	# Language in which the source code is writte
	var lang: String
end

redef class MissionStar
	# Check if the star is unlocked for the `program`
	# Also update `status`
	fun check(program: Program, status: MissionStatus): Bool do return false
end

redef class ScoreStar
	redef fun check(program, status) do
		var score = self.score(program)
		if score == null then return false

		# Search or create the corresponding StarStatus
		# Just iterate the array
		var star_status = null
		for ss in status.star_status do
			if ss.star == self then
				star_status = ss
				break
			end
		end
		if star_status == null then
			star_status = new StarStatus(self)
			status.star_status.add star_status
		end

		# Best score?
		var best = star_status.best_score
		if best == null or score < best then
			star_status.best_score = score
			if best != null then print "STAR new best score {title}. {score} < {best}"
		end

		# Star granted?
		if not status.stars.has(self) and score <= goal then
			status.stars.add self
			star_status.is_unlocked = true
			print "STAR unlocked {title}. {score} <= {goal}"
			return true
		end
		return false
	end

	# The specific score in program associated to `self`
	fun score(program: Program): nullable Int is abstract
end

redef class TimeStar
	redef fun score(program) do return program.time_score
end

redef class SizeStar
	redef fun score(program) do return program.size_score
end

# A specific execution of a test case by a program
class TestResult
	super Entity
	serialize

	# The test case considered
	var testcase: TestCase

	# The program considered
	var program: Program

	# The output of the `program` when feed by `testcase.provided_input`.
	var produced_output: nullable String = null is writable

	# Error message
	# Is `null` if success
	var error: nullable String = null is writable

	# Execution time
	var time_score: Int = 0 is writable
end
