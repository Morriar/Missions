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

# Base for code runners of a kind
module engine_base

import submissions
import base64

# Environment used for the execution of a test
class TestEnvironment
	# Workspace for the test
	var workspace: String
	# Input file path
	var input_file: String
	# Output file path
	var output_file: String
	# Expected result file path
	var save_file: String
	# Temporary directory in which the files are stored
	var temporary_dir: String
end

# Any class capable of running some code in a defined language
class Engine
	# Which language is supported by the engine?
	fun language: String is abstract

	# Extension for a source file in target language
	fun extension: String is abstract

	# Compile and run the tests for `submission`
	#
	# The job of the function is to:
	#
	# * prepare the compilation and execution environment
	# * run the compilation&execution in a sanboxed environment
	# * retrieve the results
	fun run(submission: Submission, config: AppConfig) do
		submission.status = "pending"

		var ok = prepare_workspace(submission)
		if not ok then
			submission.status = "error"
			submission.update_status(config)
			return
		end

		ok = execute(submission)
		submission.compilation_failed = not ok
		if not ok then
			submission.status = "error"
			submission.update_status(config)
			return
		end

		var errors = 0
		var time = 0
		for res in submission.results do
			check_test_result(submission, res)
			time += res.time_score
			if res.error != null then errors += 1
		end
		if errors != 0 then
			submission.status = "error"
		else
			submission.status = "success"
		end
		submission.time_score = time
		submission.test_errors = errors
		submission.update_status(config)
	end

	# Execute the compilation and test in a sandboxed environment
	# Return `false` if there is a compilation error that prevent the execution on the tests
	fun execute(submission: Submission): Bool is abstract

	# Check a test `test` for `submission`
	fun check_test_result(submission: Submission, res: TestResult) do
		var test = res.testcase
		var ts = res.testspace
		if ts == null then
			print_error "No test_space"
			return
		end

		# Prepare the sav for diffing
		var ofile = ts / "output.txt"
		var sfile = ts / "sav.txt"
		test.expected_output.write_to_file(sfile)

		# Compare the result with diff
		# TODO: some HTML-rich diff? Maybe client-side?
		res.produced_output = ofile.to_path.read_all
		var r = system("cd {ts} && diff -u sav.txt output.txt > diff.txt")
		if r != 0 then
			var out = (ts/"diff.txt").to_path.read_all
			res.error = "Error: the result is not the expected one"
			res.diff = out
		end
	end

	# Make a workspace for the submission
	fun make_workspace: nullable String do
		# Get a workspace
		# We need to create a unique working directory
		# The following is not thread/process safe
		var ws
		var z = 0
		loop
			# Get a unique timestamp for this submission
			# The loop only checks for the case in which two
			# folders with the same timestamp are created within the same
			# workspace.
			# This might be an issue when Nitcorn is properly concurrent
			# TODO: Update for safer concurrency once Nitcorn supports it.
			var date = "{get_time}_{z}"
			ws = "out/{date}"
			if not ws.file_exists then break
			z += 1
		end
		var ret = ws.mkdir
		if ret != null then
			print "Cannot make workspace due to error: {ret}"
			return null
		end
		return ws
	end

	# Prepare workspace and copy files for compilation and tests
	fun prepare_workspace(submission: Submission): Bool do
		var source = submission.source

		var ws = make_workspace
		if ws == null then
			submission.compilation_failed = true
			submission.compilation_messages = "Unable to make workspace for the submission"
			return false
		end
		submission.workspace = ws

		print "ws: {ws}"

		# Copy source
		var sourcefile = ws / "source.{extension}"
		source.write_to_file(sourcefile)

		# Copy each test input
		var tests = submission.mission.testsuite
		for test in tests do
			# Prepare a new test result for the test case
			var res = new TestResult(test)
			submission.results.add res

			# We get a subdirectory (a testspace) for each test case
			var tdir = "test{test.number}"
			var ts = ws / tdir
			ts.mkdir
			res.testspace = ts

			# Copy the input-file
			var ifile = ts / "input.txt"
			test.provided_input.write_to_file(ifile)
			# We do not copy the expected result yet, to avoid leaks
		end

		return true
	end
end

redef class TestResult
	# The directory where the test is saved
	var testspace: nullable String = null
end
