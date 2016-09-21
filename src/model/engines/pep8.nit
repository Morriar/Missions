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

# Pep/8 terminal engine for submissions
#
# TODO: Pep8Term is crap software to install and to execute.
# Currently, this program assume that it is installed in the subdirectory `pep8term`.
# Use `make pep8term` to install and compile it.
module pep8

import engine_base

# The absolute path of a `file` in pep8term.
# Aborts if not found
fun pep8term(file: String): String do
	var dir = "pep8term"
	if not dir.file_exists then
		print_error "{dir}: does not exists. Please install it (make pep8term)."
		exit 1
	end
	file = dir.realpath / file
	if not file.file_exists then
		print_error "{file}: does not exists. Please check the pep8term installation."
		exit 1
	end
	return file
end

# Handler for a Pep/8 submission
class Pep8Engine
	super Engine

	redef fun language do return "Pep/8"

	redef fun extension do return "pep"

	redef fun execute(submission)
	do
		var ws = submission.workspace
		if ws == null then return false

		# Copy scripts and requirements
		system("cp {pep8term("trap")} {pep8term("pep8os.pepo")} {pep8term("asem8")} {pep8term("pep8")} share/peprun.sh {ws}")

		# Run the payload
		system("share/saferun.sh {ws} ./peprun.sh")

		# Retrieve information
		var objfile = ws / "source.pepo"
		if not objfile.file_exists then
			var err = (ws/"cmperr.txt").to_path.read_all
			submission.compilation.message = "compilation error: {err}"
			return false
		end

		# Compilation OK: get some score
		submission.size_score = objfile.to_path.read_all.split(" ").length - 1

		for res in submission.results do
			var ts = res.testspace
			if ts == null then return false
			var instr_cpt = (ts/"timescore.txt").to_path.read_all.trim
			if instr_cpt.is_int then res.time_score = instr_cpt.to_i
		end

		return true
	end
end
