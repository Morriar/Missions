# Copyright 2017 Alexandre Terrasa <alexandre@moz-code.org>.
#
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

module test_pep8 is test

import test_base
import model::loader
import api::engine_configuration

class Pep8Test
	super TestBase
	test

	fun test_track_load is test do
		var mission = config.missions.find_all.first
		assert mission.title == "Addition simple"
		assert mission.testsuite.length == 4
	end

	fun test_compilation_error is test do
		var player = new_player("p1")
		var source = ""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["pep8term"]
		runner.run(sub, config)

		assert sub.status == "error"
		assert sub.test_errors == 0
		assert sub.results.length == 0
		assert sub.size_score == null
		assert sub.time_score == null
		assert sub.compilation.message == """
compilation error: 1 error was detected. No object code generated.
Error on line 2: Missing .END sentinal
"""
	end

	fun test_bad_input1 is test do
		var player = new_player("p2")
		var source = """
DECO 10,i
.END
"""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["pep8term"]
		runner.run(sub, config)
		assert sub.status == "error"
		assert sub.test_errors == 3
		assert sub.results.length == 4
	end

	fun test_good_input1 is test do
		var player = new_player("p2")
		var source = """
DECI n,d
LDA n,d
ADDA 10,i
STA n,d
DECO n,d
STOP
n: .BLOCK 3
.END
"""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["pep8term"]
		runner.run(sub, config)
		assert sub.status == "success"
		assert sub.test_errors == 0
		assert sub.results.length == 4
		assert sub.star_results.length == 2
	end

	fun test_good_input2 is test do
		var player = new_player("p3")
		var source = """
DECI n,d
LDA n,d
ADDA 10,i
STA n,d
DECO n,d
STOP
n: .BLOCK 2
.END
"""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["pep8term"]
		runner.run(sub, config)
		assert sub.status == "success"
		assert sub.test_errors == 0
		assert sub.results.length == 4
		assert sub.star_results.length == 2
	end

	fun test_good_input3 is test do
		var player = new_player("p4")
		var source = """
DECI 0,d
LDA 0,d
ADDA 10,i
STA 0,d
DECO 0,d
STOP
.END
"""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["pep8term"]
		runner.run(sub, config)
		assert sub.status == "success"
		assert sub.test_errors == 0
		assert sub.results.length == 4
		assert sub.star_results.length == 2
	end
end

fun before_module is before_all do
	var config = new AppConfig
	config.parse_options(new Array[String])
	var loader = new Loader(config)
	loader.load_track("tracks/pep8")
end

redef fun after_module do super
