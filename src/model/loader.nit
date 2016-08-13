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
# Load mission and tracks from the file system

module loader

import missions
import markdown

private import poset

redef class Track
	# Load the missions from the directory `path`.
	fun load_missions(config: AppConfig, path: String) do
		var files = path.files.to_a
		default_comparator.sort(files)

		var missions = new POSet[Mission]
		var mission_by_name = new HashMap[String, Mission]

		# Process files
		for f in files do
			var ff = path / f
			var mission = ff / "mission.md"
			if not mission.file_exists then continue
			var ini = new ConfigTree(ff / "config.ini")

			var name = f.basename
			var title = ini["title"]
			if title == null then
				print_error "{name}: no title in {ini}"
				title = name
			end

			var content = mission.to_path.read_all
			if content.is_empty then print_error "{name}: no {mission}"
			var proc = new MarkdownProcessor
			var html = proc.process(content).write_to_string

			# TODO: drop mango_ids and use semantic id.
			var title_id = title.strip_id

			var m = new Mission(self, title, html)
			mission_by_name[name] = m

			var reqs = ini["req"]
			if reqs != null then for r in reqs.split(",") do
				r = r.trim
				m.parents.add r
			end

			print "{ff}: got «{m.title}»"

			missions.add_node m
		end

		for m in missions do
			# The mangoid of the parents
			var reals = new Array[String]
			for r in m.parents do
				var rm = mission_by_name.get_or_null(r)
				if rm == null then
					print_error "{m}: unknown requirement {r}"
				else if missions.has_edge(rm, m) then
					print_error "{m}: circular requirement with {rm}"
				else
					missions.add_edge(m, rm)
					reals.add rm.id
				end
			end

			# replace parents' id and save
			m.parents.clear
			m.parents.add_all reals
			config.missions.save(m)
		end
	end
end

redef class String
	# Replace sequences of non-alphanumerical characters by underscore.
	#
	# ~~~
	# assert "abcXYZ123_" == "abcXYZ123_"
	# assert ", 'A[]\nB#$_" == "A_B"
	# ~~~
	fun strip_id: String
	do
		var res = new Buffer
		var sp = false
		for c in chars do
			if not c.is_alpha then
				sp = true
				continue
			end
			if sp then
				res.add '_'
				sp = false
			end
			res.add c
		end
		return res.to_s
	end
end
