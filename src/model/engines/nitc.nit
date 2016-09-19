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

	redef fun execute(submission) do
		var ws = submission.workspace
		if ws == null then return false

		# Copy scripts and requirements
		system("cp share/nitcrun.sh {ws}")

		# Run the payload
		var ok = system("share/saferun.sh {ws} ./nitcrun.sh")

		# Check compilation errors
		if ok != 0 then
			var err = (ws/"cmperr.txt").to_path.read_all
			submission.compilation_messages = "compilation error: {err}"
			return false
		end

		# Get the size score
		var file_stat = (ws / "source.nit").to_path.stat
		if file_stat == null then
			print "Error: cannot stat source file"
			return false
		end
		submission.size_score = file_stat.size

		for res in submission.results do
			var ts = res.testspace
			if ts == null then return false
			var instr_cpt = (ts/"timescore.txt").to_path.read_all.trim
			if instr_cpt.is_int then res.time_score = instr_cpt.to_i
		end

		return true
	end
end
