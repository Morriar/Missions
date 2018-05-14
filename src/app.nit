# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
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

import api

var config = new AppConfig

var usage = new Buffer
usage.append "Usage: app [OPTION]...\n"
usage.append "Missions web server."
config.tool_description = usage.write_to_string

config.parse_options(args)

if config.help then
	config.usage
	exit 0
end


var app = new App

app.use_before("/*", new SessionInit)
app.use_before("/*", new SessionRefresh(config))

app.use("/auth", new AuthRouter(config))
app.use("/api", new APIRouter(config))
app.use("/data", new StaticHandler("data"))
app.use("/*", new StaticHandler("www", "index.html"))

app.use_after("/*", new ConsoleLog)

app.listen(config.app_host, config.app_port)
