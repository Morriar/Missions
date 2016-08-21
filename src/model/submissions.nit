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

# Player's submission for Pep8 missions
#
# TODO: Pep8Term is crap software to install and to execute.
# Currently, this program assume that it is installed in the subdirectory `pep8term`.
# Use `make pep8term` to install and compile it.
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
	var status: String = "submitted"

	# The name of the working directory.
	# It is where the source is saved and artifacts are generated.
	var workspace: nullable String = null

	# Object file size in bytes.
	#
	# Use only if status == "success".
	var size_score: nullable Int = null

	# Total execution time in number of instruction.
	#
	# Use only if status == "success".
	var time_score: nullable Int = null

	# Compilation error messages
	#
	# Is null if no error.
	var compilation_error: nullable String = null

	# Number of failed test-cases
	var test_errors: Int = 0

	# Full validation of the program
	fun check(config: AppConfig)
	do
		status = "pending"

		# Get a workspace
		# We need to create a unique working directory
		# The following is not thread/process safe
		var ws
		var z = 0
		loop
			var date = (new TimeT).to_i.to_s + "_" + z.to_s
			ws = "out/{date}"
			if not ws.file_exists then break
			z += 1
		end
		ws.mkdir
		workspace = ws
		print "{player}/{mission} compile in {ws}"

		# Copy source
		var sourcefile = ws / "source.pep"
		source.write_to_file(sourcefile)

		# Try to compile
		system("cp {pep8term("trap")} {pep8term("pep8os.pepo")} {ws} && cd {ws} && {pep8term("asem8")} source.pep 2> cmperr.txt")
		var objfile = ws / "source.pepo"
		if not objfile.file_exists then
			var err = (ws/"cmperr.txt").to_path.read_all
			compilation_error = "compilation error: {err}"
			status = "error"
			return
		end

		# Compilation OK: get some score
		size_score = objfile.to_path.read_all.split(" ").length - 1

		# Execute each testcase
		var i = 0 # test number
		var time_score = 0
		var errors = 0
		for test in mission.testsuite do
			var result = test.run(self, i)
			results[test] = result
			time_score += result.time_score
			if result.error != null then errors += 1
			i += 1
		end
		self.test_errors = errors
		self.time_score = time_score
		if errors != 0 then
			status = "error"
			return
		end

		# Succes. Update the mission status
		status = "success"

		var mission_status = config.missions_status.find_by_mission_and_player(mission, player)
		if mission_status == null then
			mission_status = new MissionStatus(mission, player)
		end
		mission_status.status = status

		# Update/unlock stars
		for star in mission.stars do star.check(self, mission_status)

		config.missions_status.save(mission_status)
	end
end

redef class TestCase
	# Try the test case on a `program`.
	fun run(program: Program, i: Int): TestResult do
		var res = new TestResult(self, program)

		# We get a subdirectory (a testspace) for each test case
		var ws = program.workspace.as(not null)
		var tdir = "test{i}"
		var ts = ws / tdir
		ts.mkdir

		# Prepare the input/output
		var ifile = ts / "input.txt"
		self.provided_input.write_to_file(ifile)
		var ofile = ts / "output.txt"
		var sfile = ts / "sav.txt"
		self.expected_output.write_to_file(sfile)

		# Prepare the execution command
		# Because `pep8` is interactive.
		var canned_command = """
l
source
i
f
{{{tdir}}}/input.txt
o
f
{{{tdir}}}/output.txt
x
q
"""
		canned_command.write_to_file(ts/"canned_command")

		# Try to execute the program on the test input
		# TODO: some time/space limit!
		var r = system("cd {ws} && {pep8term("pep8")} < {tdir}/canned_command > /dev/null 2> {tdir}/execerr.txt")
		if r != 0 then
			var out = (ts/"execerr.txt").to_path.read_all
			res.error = "Execution error, contact the administrator: {out}"
			return res
		end

		var instr_cpt = (ts/"execerr.txt").to_path.read_all.trim
		res.time_score = instr_cpt.to_i

		# Compare the result with diff
		# TODO: some HTML-rich diff? Maybe client-side?
		res.produced_output = ofile.to_path.read_all
		r = system("cd {ws} && echo '' >> {tdir}/output.txt && diff -u {tdir}/sav.txt {tdir}/output.txt > {tdir}/diff.txt")
		if r != 0 then
			var out = (ts/"diff.txt").to_path.read_all
			res.error = "Error: the result is not the expected one\n{out}"
			return res
		end

		return res
	end
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
	# The test case considered
	var testcase: TestCase

	# The program considered
	var program: Program

	# The output of the `program` when feed by `testcase.provided_input`.
	var produced_output: nullable String = null

	# Error message
	# Is `null` if success
	var error: nullable String = null

	# Execution time, in number of instructions.
	var time_score: Int = 0
end
