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

	# Compile and run the tests for `program`
	fun run(program: Program, config: AppConfig) do
		program.status = "pending"
		var runnable = compile(program)
		program.compilation_failed = not runnable
		if not runnable then
			program.status = "error"
			program.update_status(config)
			return
		end
		var tests = program.mission.testsuite
		var errors = 0
		var time = 0
		for i in tests do
			var res = run_test(program, i)
			time += res.time_score
			program.results[i] = res
			if res.error != null then errors += 1
		end
		if errors != 0 then
			program.status = "error"
		else
			program.status = "success"
		end
		program.time_score = time
		program.test_errors = errors
		program.update_status(config)
	end

	# Compile `program` and check for errors and warnings
	fun compile(program: Program): Bool is abstract

	# Run `test` for `program`
	fun run_test(program: Program, test: TestCase): TestResult is abstract
end
