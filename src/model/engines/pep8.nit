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

	redef fun compile(program)
	do
		var player = program.player
		var mission = program.mission
		var source = program.source

		# Get a workspace
		# We need to create a unique working directory
		# The following is not thread/process safe
		var ws
		var z = 0
		loop
			# Get a unique timestamp for this submission
			var date = (new TimeT).to_i.to_s + "_" + z.to_s
			ws = "out/{date}"
			if not ws.file_exists then break
			z += 1
		end
		ws.mkdir
		program.workspace = ws
		print "{player}/{mission} compiled in {ws}"

		# Copy source
		var sourcefile = ws / "source.pep"
		source.write_to_file(sourcefile)

		# Try to compile
		system("cp {pep8term("trap")} {pep8term("pep8os.pepo")} {ws} && cd {ws} && {pep8term("asem8")} source.pep 2> cmperr.txt")
		var objfile = ws / "source.pepo"
		if not objfile.file_exists then
			var err = (ws/"cmperr.txt").to_path.read_all
			program.compilation_messages = "compilation error: {err}"
			return false
		end

		# Compilation OK: get some score
		program.size_score = objfile.to_path.read_all.split(" ").length - 1

		return true
	end

	redef fun run_test(program, test) do
		var res = new TestResult(test, program)

		var tdir = "{program.mission.id}_{program.player.id}"
		# We get a subdirectory (a testspace) for each test case
		var ws = program.workspace.as(not null)
		var ts = ws / tdir
		ts.mkdir

		# Prepare the input/output
		var ifile = ts / "input.txt"
		test.provided_input.write_to_file(ifile)
		var ofile = ts / "output.txt"
		var sfile = ts / "sav.txt"
		test.expected_output.write_to_file(sfile)

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
