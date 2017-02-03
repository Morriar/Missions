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

module test_useocl is test_suite

import test_base
import model::loader
import api::engine_configuration

class UseOclTest
	super TestBase

	fun test_track_load do
		var mission = config.missions.find_all.first
		assert mission.title == "Classes"
		assert mission.testsuite.length == 2
	end

	fun test_compilation_error do
		var player = new_player("p1")
		var source = ""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["use-ocl"]
		runner.run(sub, config)

		assert sub.status == "error"
		assert sub.test_errors == 0
		assert sub.results.length == 0
		assert sub.size_score == null
		assert sub.time_score == null
		assert sub.compilation.message == """
compilation error: source.use:line 1:0 mismatched input '<EOF>' expecting 'model'
"""
	end

	fun test_bad_input1 do
		var player = new_player("p2")
		var source = """
model bank

class BankAccount
	attributes
		balance: Integer
end

constraints

context BankAccount
	inv: balance >= 0
"""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["use-ocl"]
		runner.run(sub, config)
		assert sub.status == "error"
		assert sub.test_errors == 2
		assert sub.results.length == 2
	end

	fun test_good_input1 do
		var player = new_player("p2")
		var source = """
model SpaceZ

abstract class Vaisseau
	attributes
		poids: Integer
	operations
		decoller()
end

class VaisseauCargo < Vaisseau
	attributes
		capacite: Integer
	operations
		charger(poids: Integer)
end

class VaisseauCombat < Vaisseau
	operations
		attaquer(vaisseau: Vaisseau)
end
"""
		var mission = config.missions.find_all.first
		var sub = new Submission(player, mission, source)
		var runner = config.engine_map["use-ocl"]
		runner.run(sub, config)
		assert sub.status == "success"
		assert sub.test_errors == 0
		assert sub.results.length == 2
	end
end

redef fun before_module do
	var config = new AppConfig
	config.parse_options(new Array[String])
	var loader = new Loader(config)
	loader.load_track("tracks/use-ocl")
end

redef fun after_module do super
