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

# Nitc engine for Nit submissions
module nitc

import engine_base
import realtime

# Nit compiler for program submission
class NitcEngine
	super Engine

	redef fun language do return "Nit"

	redef fun extension do return "nit"

	redef fun compile(submission) do
		var ws = submission.workspace
		if ws == null then return false

		var file_stat = (ws / "source.nit").to_path.stat
		if file_stat == null then
			print "Error: cannot stat source file"
			return false
		end
		submission.size_score = file_stat.size

		# Try to compile
		system("mkdir -p {ws}/bin && nitc {ws}/source.nit -o {ws}/bin/source 2> {ws}/cmperr.txt")

		if not "{ws}/bin/source".file_exists then
			var err = (ws/"cmperr.txt").to_path.read_all
			submission.compilation_messages = "compilation error: {err}"
			return false
		end

		return true
	end

	redef fun execute_test(submission, res, env) do
		var ws = env.workspace
		var tdir = env.temporary_dir
		var ts = ws / tdir
		# Try to execute the submission on the test input
		# TODO: some time/space limit!
		var time = new Timespec.monotonic_now
		var ms_start = time.millisec
		#print "./{ws}/bin/source < {env.input_file} 2> {ts}/execerr.txt 1> {env.output_file}"
		var r = system("./{ws}/bin/source < {env.input_file} 2> {ts}/execerr.txt 1> {env.output_file}")
		time.update
		var ms_end = time.millisec
		res.time_score = ms_end - ms_start
		if r != 0 then
			var out = (ts/"execerr.txt").to_path.read_all
			res.error = "Execution error, contact the administrator: {out}"
			return
		end
	end
end
