# Wrapping Libraries

Nit can provide automatic wrapping of extern data structures as classes.
Theses classes are declared `extern`.

The goal of extern classes is to describe data that lives in the foreign language.
Like a normal class, an extern class can define, inherit and refine methods.
Methods can even be foreign or pure Nit.
The only restriction is that extern classes cannot have attributes (data lives in the foreign world) and can only specialize interfaces or other extern classes.

The advantage of extern classes is that values are no more opaque in extern methods.
When an extern class is used to type a parameter or the return value of an extern method,
the value is then directly accessible.

The foreign type is indicated after the class name with the now traditional back-quoted curly-bracket notation.

<!--
~~~nit
`{
#include <sys/types.h>
#include <dirent.h>
`}

extern class CDir `{ DIR* `}
        # Open a directory
        new(path: NativeString) `{ return opendir(path); `}

        # Close a directory
        fun closedir `{ closedir(self); `}

        # Read the next directory entry
        fun readdir: NativeString `{
                struct dirent *de;
                de = readdir(self);
                if (!de) return NULL;
                return de->d_name;
        `}
end

# Simple client
# Disclaimer: Usually it is often a better idea to add another API level to avoid
# the direct manipulation of foreign values.
var dir = new CDir(".".to_cstring)
loop
	var ent = dir.readdir
	if ent.address_is_null then break
	print ent.to_s
end
dir.closedir
~~~
-->

<pre class="hl"><span class="hl str">`{</span>
<span class="hl str">#include &lt;systypes.h</span>
<span class="hl str">#include &lt;dirent.h</span>
<span class="hl str">`</span><span class="hl opt">}</span>

<span class="hl kwa">extern class</span> <span class="hl kwb">CDir</span> <span class="hl str">`</span><span class="hl esc">{ DIR* `}</span>
<span class="hl str">        # Open a directory</span>
<span class="hl str">        new(path: NativeString) `</span><span class="hl esc">{ return opendir(path); `}</span>

        <span class="hl slc"># Close a directory</span>
        <span class="hl kwa">fun</span> closedir <span class="hl str">`</span><span class="hl esc">{ closedir(self); `}</span>
<span class="hl str"></span>
<span class="hl str">        # Read the next directory entry</span>
<span class="hl str">        fun readdir: NativeString `</span><span class="hl opt">{</span>
                struct dirent <span class="hl opt">*</span>de<span class="hl opt">;</span>
                de <span class="hl opt">=</span> readdir<span class="hl opt">(</span><span class="hl kwa">self</span><span class="hl opt">);</span>
                <span class="hl kwa">if</span> <span class="hl opt">(!</span>de<span class="hl opt">)</span> <span class="hl kwa">return</span> <span class="hl kwb">NULL</span><span class="hl opt">;</span>
                <span class="hl kwa">return</span> de-&gt;d_name<span class="hl opt">;</span>
        <span class="hl str">`}</span>
<span class="hl str">end</span>
<span class="hl str"></span>
<span class="hl str"># Simple client</span>
<span class="hl str"># Disclaimer: Usually it is often a better idea to add another API level to avoid</span>
<span class="hl str"># the direct manipulation of foreign values.</span>
<span class="hl str">var dir = new CDir(&quot;.&quot;.to_cstring)</span>
<span class="hl str">loop</span>
<span class="hl str">	var ent = dir.readdir</span>
<span class="hl str">	if ent.address_is_null then break</span>
<span class="hl str">	print ent.to_s</span>
<span class="hl str">end</span>
<span class="hl str">dir.closedir</span>
</pre>

Some included foreign code may require specific compilation flags.
These flags can be declared in the module declaration.

Most of the time for C and C++ foreign code, the tool `pkg-config` can be used to correctly get these flags.
`nitc` simplifies the process for you.

<!--
module curl is pkgconfig

# Rest of the code...
-->

<pre class="hl"><span class="hl kwa">module</span> curl <span class="hl kwa">is</span> pkgconfig

<span class="hl slc"># Rest of the code...</span>
</pre>

## Mission

* Difficulty: advanced

Write a simple wrapper around [libcaca](http://caca.zoy.org/doxygen/libcaca/caca_8h.html) that includes the following data types and functions:

You need to wrap the following:

* `caca_display_t` as `CadaDisplay`
* `caca_get_canvas` as `CadaDisplay::canvas`
* `caca_refresh_display` as `CadaDisplay::refresh`
* `caca_canvas_t` as `CacaCanvas`
* `caca_put_str` as `CacaCanvas::put`

Also add a `CadaDisplay::quit` that waits for any input event, then destroys the display.

Here an example of a working client.

<!--~~~nit
module caca_client

import caca

var d = new CacaDisplay
var c = d.canvas
c.put("Hello, World!", 5, 1)
d.refresh
d.quit
~~~-->

<pre class="hl"><span class="hl kwa">module</span> caca_client

<span class="hl kwa">import</span> caca

<span class="hl kwa">var</span> d <span class="hl opt">=</span> <span class="hl kwa">new</span> <span class="hl kwb">CacaDisplay</span>
<span class="hl kwa">var</span> c <span class="hl opt">=</span> d<span class="hl opt">.</span>canvas
c<span class="hl opt">.</span>put<span class="hl opt">(</span><span class="hl str">&quot;Hello, World&quot;</span><span class="hl opt">,</span> <span class="hl num">5</span><span class="hl opt">,</span> <span class="hl num">1</span><span class="hl opt">)</span>
d<span class="hl opt">.</span>refresh
d<span class="hl opt">.</span>quit
</pre>

Look at the [caca tutorial](http://caca.zoy.org/doxygen/libcaca/libcaca-tutorial.html) and the [caca header file](http://caca.zoy.org/doxygen/libcaca/caca_8h.html) for more information.

### Template to Use

<!--~~~nit
module caca is pkgconfig

# CODE HERE
~~~-->

<pre class="hl"><span class="hl kwa">module</span> caca <span class="hl kwa">is</span> pkgconfig

<span class="hl slc"># CODE HERE</span>
</pre>

### Expected Result

A window with "Hello, World!" at (5,1) when executing `caca_client` compiled with your lib.
