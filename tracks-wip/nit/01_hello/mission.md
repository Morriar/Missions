# Hello, World!

Nit is a statically typed language that aims at elegance, simplicity and intuitiveness.

For instance, `print` is a function that prints something at the screen.

<pre class="hl">print <span class="hl str">&quot;I print therefore I am.&quot;</span>
</pre>


In fact, `print` is a method from the core library that accepts any kind of objects and prints a human-readable form to standard output; but these concepts will be introduced later.

Nit can be either compiled (with `nitc`) or interpreted (with `nit`).
Bonus: if the source code has the right permissions and starts with `#!/usr/bin/env nit`, it can be executed directly.

	$ cat rene.nit
	#!/usr/bin/env nit
	print "I print therefore I am."

	$ nitc rene.nit
	$ ./rene
	I print therefore I am.

	$ nit rene.nit
	I print therefore I am.

	$ chmod +x rene.nit
	$ ./rene.nit
	I print therefore I am.

## Mission

* Difficulty: basic

To prove your achievement, develop the traditional *Hello, World!*

For all the missions in this tutorial, you can test your Nit source code on [http://test.nitlanguage.org/](http://test.nitlanguage.org/).

### Template to Use

For each mission, a template is provided.

* You must use it.
* You can only write your code in the specified places
* You cannot modify other parts.

The template of the mission is the following one:

<pre class="hl"><span class="hl kwa">module</span> hello
<span class="hl slc"># CHANGE BELOW</span>
print <span class="hl str">&quot;Something, Something&quot;</span>
<span class="hl slc"># CHANGE ABOVE</span>
</pre>

### Expected Output

	Hello, World!
