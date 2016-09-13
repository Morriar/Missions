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
class Submission
	super Event
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
	var results = new Array[TestResult]

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
	var time_score: nullable Int = null is writable

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

	# The aggregated mission status after the submission
	var mission_status: nullable MissionStatus = null

	# The events thrown by the submission
	var events = new Array[Event]

	# Update status of `self` in DB
	fun update_status(config: AppConfig) do
		var mission_status = player.mission_status(config, mission)
		self.mission_status = mission_status

		# Update/unlock stars
		if successful then
			if mission_status.status != "success" then
				# new solve
				var solve = new Solve(mission)
				events.add solve
			end
			mission_status.status = "success"
			for star in mission.stars do star.check(self, mission_status)

			# Unlock next missions
			for mission in mission.load_children(config) do
				var cstatus = player.mission_status(config, mission)
				cstatus.status = "open"
				config.missions_status.save(cstatus)
			end
		end

		config.missions_status.save(mission_status)
	end

	redef fun to_json do return serialize_to_json
end

# This model provides easy deserialization of posted submission forms
class SubmissionForm
	serialize

	# Source code to be run
	var source: String
	# Engine or runner to be used
	var engine: String
	# Language in which the source code is writte
	var lang: String
end

redef class MissionStar
	# Check if the star is unlocked for the `submission`
	# Also update `status`
	fun check(submission: Submission, status: MissionStatus): Bool do return false
end

redef class ScoreStar
	redef fun check(submission, status) do
		# Search or create the corresponding StarStatus
		# Just iterate the array
		var star_status = null
		for ss in status.stars_status do
			if ss.star == self then
				star_status = ss
				break
			end
		end
		if star_status == null then
			star_status = new StarStatus(self)
			status.stars_status.add star_status
		end

		if not submission.successful then return false

		var score = self.score(submission)
		if score == null then return false

		# Best score?
		var newscore = null
		var best = star_status.best_score
		if best == null or score < best then
			star_status.best_score = score
			newscore = new NewHighScore(self, goal, best, score)
			submission.events.add newscore
		end

		# Star granted?
		if not status.unlocked_stars.has(self) and score <= goal then
			star_status.is_unlocked = true
			var unlock = new StarUnlock(self, newscore)
			submission.events.add unlock
			return true
		end
		return false
	end

	# The specific score in submission associated to `self`
	fun score(submission: Submission): nullable Int is abstract

	# The key in the Submission object used to store the star `score`
	#
	# So we can factorize things in the HTML output.
	fun submission_key: String is abstract
end

redef class TimeStar
	serialize

	redef fun score(submission) do return submission.time_score
	redef var submission_key = "time_score"
end

redef class SizeStar
	serialize

	redef fun score(submission) do return submission.size_score
	redef var submission_key = "size_score"
end

# A specific execution of a test case by a submission
class TestResult
	super Entity
	serialize

	# The test case considered
	var testcase: TestCase

	# The output of the `submission` when feed by `testcase.provided_input`.
	var produced_output: nullable String = null is writable

	# Error message
	# Is `null` if success
	var error: nullable String = null is writable

	# Result diff (if any)
	var diff: nullable String = null is writable

	# Execution time
	var time_score: Int = 0 is writable
end

# A player solved a mission
class Solve
	super Event
	serialize

	# The associated mission
	var mission: Mission

	redef fun to_s do
		return "SOLVE {mission.title}"
	end
end

# A player beat a star score
class NewHighScore
	super Event
	serialize

	# Information about the star
	var star: MissionStar

	# The goal of the star
	var goal: Int

	# The previous score, if any
	var old_score: nullable Int

	# The new score
	var new_score: Int

	redef fun to_s do
		var best = old_score
		if best != null then
			return "STAR new best score {star.title}. {new_score} < {best}"
		else
			return "STAR new score {star.title}. {new_score}"
		end
	end
end

# A player got a star!
class StarUnlock
	super Event
	serialize

	# Information about the star
	var star: MissionStar

	# If the star is a score star, the associated score information
	var score: nullable NewHighScore

	redef fun to_s do
		var score = self.score
		if score != null then
			return "STAR unlocked {star.title}. {score.new_score} <= {score.goal}"
		else
			return "STAR unlocked {star.title}."
		end
	end
end
