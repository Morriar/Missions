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
	fun run(submission: Submission, config: AppConfig) do
		submission.status = "pending"
		var can_compile = prepare_compilation(submission)
		if not can_compile then
			submission.status = "error"
			submission.update_status(config)
			return
		end
		var runnable = compile(submission)
		submission.compilation_failed = not runnable
		if not runnable then
			submission.status = "error"
			submission.update_status(config)
			return
		end
		var tests = submission.mission.testsuite
		var errors = 0
		var time = 0
		for i in tests do
			var res = run_test(submission, i)
			time += res.time_score
			submission.results.add res
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

	# Compile `submission` and check for errors and warnings
	fun compile(submission: Submission): Bool is abstract

	# Run `test` for `submission`
	fun run_test(submission: Submission, test: TestCase): TestResult do
		var res = new TestResult(test)

		var tdir = "test{submission.results.length + 1}"
		# We get a subdirectory (a testspace) for each test case
		#
		# NOTE: The `as(not null)` is actually safe since `prepare_compilation` needs to be
		# called before running tests and will fail should the workspace fail to be created,
		# therefore returning a failure to the client.
		var ws = submission.workspace.as(not null)
		var ts = ws / tdir
		ts.mkdir

		# Prepare the input/output
		var ifile = ts / "input.txt"
		test.provided_input.write_to_file(ifile)
		var ofile = ts / "output.txt"
		var sfile = ts / "sav.txt"
		test.expected_output.write_to_file(sfile)

		var env = new TestEnvironment(ws, ifile, ofile, sfile, tdir)

		execute_test(submission, res, env)

		# Compare the result with diff
		# TODO: some HTML-rich diff? Maybe client-side?
		res.produced_output = ofile.to_path.read_all
		var r = system("cd {ws} && diff -u {tdir}/sav.txt {tdir}/output.txt > {tdir}/diff.txt")
		if r != 0 then
			var out = (ts/"diff.txt").to_path.read_all
			res.error = "Error: the result is not the expected one"
			res.diff = out
			return res
		end

		return res
	end

	# Executes a test on `submission`
	fun execute_test(submission: Submission, res: TestResult, env: TestEnvironment) is abstract

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

	# Prepare workspace and target file for compilation
	fun prepare_compilation(submission: Submission): Bool do
		var source = submission.source

		var ws = make_workspace
		if ws == null then
			submission.compilation_messages = "Unable to make workspace for the submission"
			return false
		end
		submission.workspace = ws

		# Copy source
		var sourcefile = ws / "source.{extension}"
		source.write_to_file(sourcefile)

		return true
	end
end
