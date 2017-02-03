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

CodeMirror.defineSimpleMode("ocl", {
	start: [
		// OCL keywords
		{regex: /(?:context|package|endpackage|if|then|else|endif|let|in|true|false|invalid|null|not|and|or|xor|implies)\b/, token: "keyword"},

		// USE-OCL keywords
		{regex: /(?:class|enum|end|association|between|role|model|constraints|attributes|operations)\b/, token: "use-ocl"},

		// OCL constraints
		{regex: /(?:inv|pre|post|body|init|derive|def)\b/, token: "constraint"},

		// Special keywords
		{regex: /(?:self|result|@pre|Set|OrderedSet|Sequence|Bag)\b/, token: "special"},

		// Comments
		{regex: /--.*/, token: "comment"},

		// String
		{ regex: /'(?:[^\\']|\\.)*'?/, token: "string" },

		// Numerical
		{ regex: /\d+/, token: "number" },
	]
});
