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

# USE-OCL engine
module use

import engine_base

# Handler for a USE-OCL submission
class UseOclEngine
	super Engine

	redef fun language do return "OCL"

	redef fun extension do return "use"

	redef fun execute(submission)
	do
		var ws = submission.workspace
		if ws == null then return false

		# Copy scripts and requirements
		system("cp share/useoclrun.sh {ws}")

		# Run the payload
		var r = system("share/saferun.sh {ws} ./useoclrun.sh")

		# Retrieve information
		if r != 0 then
			var err = (ws/"cmperr.txt").to_path.read_all
			submission.compilation.message = "compilation error: {err}"
			return false
		end

		return true
	end
end
