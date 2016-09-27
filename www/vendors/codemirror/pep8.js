/*
 * Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

CodeMirror.defineSimpleMode("pep8", {
	start: [
		// Instructions
		{regex: /(?:stop|rettr|movspa|movflga|br|brle|brlt|breq|brne|brge|brgt|brv|brc|call|nop|deci|deco|stro|chari|charo|addsp|subsp)\b/i, token: "instruction"},

		// Instructions with register
		{regex: /(?:not|neg|asl|asr|rol|ror|nop|add|sub|and|or|cp|ld|ldbyte|st|stbyte)(n|z|v|c|a|x|pp|co)\b/i, token: "instruction"},

		// Instructions with numbers
		{regex: /(?:ret)[0-9]\b/i, token: "instruction"},

		// Directives
		{regex: /(?:\.byte|\.word|\.block|\.ascii|\.addrss|\.equate|\.end|\.burn)\b/i, token: "directive"},

		// Comments
		{regex: /;.*/, token: "comment"},

		// Tags
		{regex: /^[a-z][a-z0-9_]{0,9}:/i, token: "tag"},
	]
});
