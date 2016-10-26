# Foreign Function Interface

The Nit Foreign Function Interface (FFI) allows the nesting of foreign code within a Nit source file.
Current supported languages are C, C++, Java (used mainly for android support) and Objective C (used mainly for iOS support).

Common use cases of the FFI is to optimize a method or to wrap existing system or third-party libraries.
The syntax use back-quoted curly-brackets.

<!--~~~nit
fun in_nit do print "In Nit"
fun in_c `{ printf("In C\n"); `}
fun in_cpp in "C++" `{ cout << "In C++" << endl; `}
fun in_java in "Java" `{ System.out.println("In Java"); `}
fun in_objc in "ObjC" `{ NSLog (@"In Objective C\n"); `}

in_nit
in_c
in_cpp
in_java
in_objc
~~~-->

<pre class="hl"><span class="hl kwa">fun</span> in_nit <span class="hl kwa">do</span> print <span class="hl str">&quot;In Nit&quot;</span>
<span class="hl kwa">fun</span> in_c <span class="hl str">`</span><span class="hl esc">{ printf(&quot;In C\n&quot;); `}</span>
<span class="hl str">fun in_cpp in &quot;C+&quot; `</span><span class="hl esc">{ cout &lt;&lt; &quot;In C++&quot; &lt;&lt; endl; `}</span>
<span class="hl kwa">fun</span> in_java <span class="hl kwa">in</span> <span class="hl str">&quot;Java&quot;</span> <span class="hl str">`</span><span class="hl esc">{ System.out.println(&quot;In Java&quot;); `}</span>
<span class="hl str">fun in_objc in &quot;ObjC&quot; `</span><span class="hl esc">{ NSLog (&#64;&quot;In Objective C\n&quot;); `}</span>

in_nit
in_c
in_cpp
in_java
in_objc
</pre>

Advanced features of the Nit FFI include:

* inclusion of global declarations
* automatic conversion between some Nit and foreign types
* declaration of callback functions to call Nit methods from within the foreign code.

The following example shows how can the C function `strchr` be used to search a character in a string.

<!--
~~~nit
# global FFI declaration are enclosed by `{ `}
# Use them for #include and related things.

`{
#include <string.h>
`}

# Any class can be refined with FFI method.
redef class String 
	fun strchr(c: Char): Int import to_cstring `{
		// Two parameter, `self` and `c`.
		// `self` is an opaque type in the C side
		// `c` is converted to the primitive `char`

		// Because `strchr` need a `char*`, we must convert the opaque `self`
		// to something usable.
		// the `import` clause makes the method `to_cstring` available in C.
		char *str = String_to_cstring(self);

		// In Nit, `to_cstring` returns a `NativeString`.
		// In C, `NativeString` are automatically converted to `char*`.
		char *res = strchr(str, c);
		if (res==NULL) return -1;
		return res - str;
	`}
end

print "Hello, World!".strchr('W') # 7
print "Hello, World!".strchr('*') # -1
~~~-->

<pre class="hl"><span class="hl slc"># global FFI declaration are enclosed by `{ `}</span>
<span class="hl slc"># Use them for #include and related things.</span>

<span class="hl str">`{</span>
<span class="hl str">#include &lt;string.h</span>
<span class="hl str">`</span><span class="hl opt">}</span>

<span class="hl slc"># Any class can be refined with FFI method.</span>
<span class="hl kwa">redef class</span> <span class="hl kwb">String</span> 
	<span class="hl kwa">fun</span> strchr<span class="hl opt">(</span>c<span class="hl opt">:</span> <span class="hl kwb">Char</span><span class="hl opt">):</span> <span class="hl kwb">Int</span> <span class="hl kwa">import</span> to_cstring <span class="hl str">`{</span>
<span class="hl str">		// Two parameter, `</span><span class="hl kwa">self</span><span class="hl str">` and `</span>c<span class="hl str">`.</span>
<span class="hl str">		// `</span><span class="hl kwa">self</span><span class="hl str">` is an opaque type in the C side</span>
<span class="hl str">		// `</span>c<span class="hl str">` is converted to the primitive `</span>char<span class="hl str">`</span>
<span class="hl str"></span>
<span class="hl str">		// Because `</span>strchr<span class="hl str">` need a `</span>char<span class="hl opt"></span><span class="hl str">`, we must convert the opaque `</span><span class="hl kwa">self</span><span class="hl str">`</span>
<span class="hl str">		// to something usable.</span>
<span class="hl str">		// the `</span><span class="hl kwa">import</span><span class="hl str">` clause makes the method `</span>to_cstring<span class="hl str">` available in C.</span>
<span class="hl str">		char *str = String_to_cstring(self);</span>
<span class="hl str"></span>
<span class="hl str">		// In Nit, `</span>to_cstring<span class="hl str">` returns a `</span><span class="hl kwb">NativeString</span><span class="hl str">`.</span>
<span class="hl str">		// In C, `</span><span class="hl kwb">NativeString</span><span class="hl str">` are automatically converted to `</span>char<span class="hl opt"></span><span class="hl str">`.</span>
<span class="hl str">		char *res = strchr(str, c);</span>
<span class="hl str">		if (res=NULL) return -1;</span>
<span class="hl str">		return res - str;</span>
<span class="hl str">	`</span><span class="hl opt">}</span>
<span class="hl kwa">end</span>

print <span class="hl str">&quot;Hello, World&quot;</span><span class="hl opt">.</span>strchr<span class="hl opt">(</span><span class="hl str">'W'</span><span class="hl opt">)</span> <span class="hl slc"># 7</span>
print <span class="hl str">&quot;Hello, World&quot;</span><span class="hl opt">.</span>strchr<span class="hl opt">(</span><span class="hl str">'*'</span><span class="hl opt">)</span> <span class="hl slc"># -1</span>
</pre>

## Mission

* Difficulty: easy

Refine the class `String` and add a method `fnmatch(pattern: String): Bool` that wrap the POSIX function `fnmatch` (Hint: `man fnmatch`)

### Template to Use

<!--
~~~nit
module fnmatch

# CODE HERE

print "mpire.nit".fnmatch("*.nit")
print "mpire.nit".fnmatch("*.zip")
~~~-->

<pre class="hl"><span class="hl kwa">module</span> fnmatch

<span class="hl slc"># CODE HERE</span>

print <span class="hl str">&quot;mpire.nit&quot;</span><span class="hl opt">.</span>fnmatch<span class="hl opt">(</span><span class="hl str">&quot;*.nit&quot;</span><span class="hl opt">)</span>
print <span class="hl str">&quot;mpire.nit&quot;</span><span class="hl opt">.</span>fnmatch<span class="hl opt">(</span><span class="hl str">&quot;*.zip&quot;</span><span class="hl opt">)</span>
</pre>

### Expected Output

    true
    false
