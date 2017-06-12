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

# Base model entities and services
module model_base

import config

# Base model entity
#
# All model entities are serializable to JSON.
abstract class Entity
	serialize

	# `self` unique id.
	var id: String = (new MongoObjectId).id is serialize_as "_id"

	redef fun to_s do return id
	redef fun ==(o) do return o isa SELF and id == o.id
	redef fun hash do return id.hash
	redef fun to_json do return serialize_to_json
end

# Something that occurs at some point in time
abstract class Event
	super Entity
	serialize

	# Timestamp when this event occurred.
	var timestamp: Int = get_time
end

# Remove inner references from JSON serialization
#
# Override the basic serialization process for the whole app
redef class JsonSerializer

	# Remove caching when saving refs to db
	redef fun serialize_reference(object) do serialize object
end
