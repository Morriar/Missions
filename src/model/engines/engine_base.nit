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

# Any class capable of running some code in a defined language
class Engine
	# Which language is supported by the engine?
	fun language: String is abstract

	# Compile and run the tests for `submission`
	fun run(submission: Submission, config: AppConfig) do
		submission.status = "pending"
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
			submission.results[i] = res
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
	fun run_test(submission: Submission, test: TestCase): TestResult is abstract
end
