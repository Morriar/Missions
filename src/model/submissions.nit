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

	# Unlocked missions if success and if any
	var next_missions: nullable Array[Mission] = null

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

	# Was the run the first solve?
	var is_first_solve = false

	# The aggregated mission status after the submission
	var mission_status: nullable MissionStatus = null

	# The results of each star
	var star_results = new Array[StarResult]

	# Update status of `self` in DB
	fun update_status(config: AppConfig) do
		var mission_status = player.mission_status(config, mission)
		self.mission_status = mission_status

		# Update/unlock stars
		if successful then
			if mission_status.status != "success" then
				is_first_solve = true
			end
			mission_status.status = "success"
			for star in mission.stars do star.check(self, mission_status)

			# Unlock next missions
			# Add next missions to successful submissions
			var next_missions = new Array[Mission]
			for mission in mission.load_children(config) do
				var cstatus = player.mission_status(config, mission)
				cstatus.status = "open"
				config.missions_status.save(cstatus)
				next_missions.add mission
			end
			self.next_missions = next_missions
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

		var star_result = new StarResult(self)
		submission.star_results.add star_result
		star_result.goal = goal
		star_result.new_score = score
		var best = star_status.best_score
		star_result.old_score = best

		# Best score?
		if best == null or score < best then
			star_status.best_score = score
			if best != null then
				star_result.is_highscore = true
			end
		end

		# Star granted?
		if not status.unlocked_stars.has(self) and score <= goal then
			star_status.is_unlocked = true
			star_result.is_unlocked = true
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

# The specific submission result on a star
# Unlike the star status, this shows what is *new*
class StarResult
	super Entity
	serialize

	# Information about the star
	var star: MissionStar

	# The goal of the star, if any
	var goal: nullable Int = null

	# The previous score, if any
	var old_score: nullable Int = null

	# The new score, if any
	var new_score: nullable Int = null

	# Is the star unlocked?
	var is_unlocked = false

	# Is the new_score higher than then old_score?
	var is_highscore = false

	redef fun to_s do
		var res = "STAR {star.title}"
		if is_unlocked then
			res += " UNLOCKED!"
		else if is_highscore then
			res += " NEW BEST SCORE!"
		end

		var goal = self.goal
		if goal != null then
			res += " goal: {goal}"
		end

		var new_score = self.new_score
		if new_score != null then
			res += " score: {new_score}"
		end

		var old_score = self.old_score
		if old_score != null then
			res += " (was {old_score})"
		end
		return res
	end
end
