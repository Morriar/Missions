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

module test_nitc is test

import test_base
import model::loader
import api::engine_configuration

class NitcTest
	super TestBase
	test

	fun test_track_load is test do
		var mission = config.missions.find_all.first
		assert mission.title == "Hello, World!"
		assert mission.testsuite.length == 1
	end

	fun test_empty is test do
		var player = new_player("p1")
		var source = ""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = new NitcEngine
		runner.run(sub, config)
		assert sub.status == "error"
		assert sub.test_errors == 1
		assert sub.results.length == 1
		assert sub.results.first.error == "Error: the result is not the expected one"
	end

	fun test_compilation_error is test do
		var player = new_player("p2")
		var source = "echo Hello, World!"
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = new NitcEngine
		runner.run(sub, config)
		assert sub.status == "error"
		assert sub.test_errors == 0
		assert sub.results.length == 0
	end

	fun test_bad_input1 is test do
		var player = new_player("p2")
		var source = """print "hello world""""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = new NitcEngine
		runner.run(sub, config)
		assert sub.status == "error"
		assert sub.test_errors == 1
		assert sub.results.length == 1
		assert sub.star_results.length == 0
		assert sub.results.first.error == "Error: the result is not the expected one"
	end

	fun test_good_input1 is test do
		var player = new_player("p3")
		var source = """
class Hello
	fun hi: String do return "Hello, World!"
end
print((new Hello).hi)
"""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = new NitcEngine
		runner.run(sub, config)
		assert sub.status == "success"
		assert sub.test_errors == 0
		assert sub.results.length == 1
		assert sub.star_results.length == 1
	end

	fun test_good_input2 is test do
		var player = new_player("p4")
		var source = """print "Hello, World!""""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = new NitcEngine
		runner.run(sub, config)
		assert sub.status == "success"
		assert sub.test_errors == 0
		assert sub.results.length == 1
		assert sub.star_results.length == 1
	end
end

fun before_module is before_all do
	var config = new AppConfig
	config.parse_options(new Array[String])
	var loader = new Loader(config)
	loader.load_track("tracks/nit")
end

redef fun after_module do super
