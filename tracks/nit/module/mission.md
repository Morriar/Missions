# Modules

Nit source files are called *modules*.
A module can define classes and methods, import classes and methods from other modules and refine them.

The keyword `module` can be used to declare a module. It is optional but when given, the module name must match the filename.
The `module` declaration is also used to attach the documentation and to attach specific module annotations.

The keyword `import` is used to import other modules.

<pre class="hl"><span class="hl slc"># Simple program that says hello</span>
<span class="hl kwa">module</span> hello
print <span class="hl str">&quot;Hello, World&quot;</span>
</pre>

<pre class="hl"><span class="hl slc"># I don't know why you say hello, I say goodbye</span>
<span class="hl kwa">module</span> goodbye
<span class="hl kwa">import</span> hello

<span class="hl kwa">super</span> <span class="hl slc"># Call the previous `main`</span>
print <span class="hl str">&quot;Goodbye, World&quot;</span>
</pre>

Nit promotes *Concern-Oriented Development* where each module ideally operates on a single concern.
A Nit program is just a module that imports all the required concerns.

Moreover, importation of modules can be done and configured at link-time (with `-m` and `-D`) to generate specific configurations of a product line.

<pre class="hl"><span class="hl kwa">module</span> pire
<span class="hl kwa">fun</span> ctator<span class="hl opt">:</span> <span class="hl kwb">String</span> <span class="hl kwa">do return</span> <span class="hl str">&quot;The Emperor says&quot;</span>
<span class="hl kwa">redef fun</span> print<span class="hl opt">(</span>value<span class="hl opt">)</span> <span class="hl kwa">do super</span> <span class="hl str">&quot;</span><span class="hl esc">{ctator}</span> <span class="hl str">``</span><span class="hl esc">{value}</span><span class="hl str">''&quot;</span>
</pre>

	$ nitc goodbye.nit
	$ ./goodbye
	Hello, World!
	Goodbye, World!

	$ nitc goodbye.nit -m pire.nit # -m means mixin (or module; think what you want, I'm just a comment)
	$ ./goodbye
	The Emperor says ``Hello, World!''
	The Emperor says ``Goodbye, World!''

	$ nitc goodbye.nit -m pire.nit -D ctator="The Rebels say" # -D means define
	$ ./goodbye
	The Rebels say ``Hello, World!''
	The Rebels say ``Goodbye, World!''

## Mission

* Difficulty: easy

Here a program that prints the command line arguments separated by a comma.

<pre class="hl">print args<span class="hl opt">.</span>join<span class="hl opt">(</span><span class="hl str">&quot;, &quot;</span><span class="hl opt">)</span>
</pre>

Your mission is to write a mixin module that will change the behavior of this program so it prints "`Y0u, 4r3, H4cK3d`" instead.

### Template to Use

<pre class="hl"><span class="hl kwa">module</span> hacker
<span class="hl slc"># CODE HERE</span>
</pre>

### Expected Output

	Y0u, 4r3, H4cK3d
