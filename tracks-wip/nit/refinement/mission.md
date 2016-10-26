# Class Refinement

One of the best features of Nit is refinement.

Refinement is modifying existing methods and classes in a statically controlled way:

* New methods
* New attributes
* Override methods
* New super-classes

The keyword `redef` is used to declare that a class definition is a refinement.

<pre class="hl"><span class="hl slc"># Improve the class Int with a recursive Fibonacci function.</span>
<span class="hl kwa">redef class</span> <span class="hl kwb">Int</span>
   <span class="hl kwa">fun</span> fib<span class="hl opt">:</span> <span class="hl kwb">Int</span> <span class="hl kwa">do</span>
      <span class="hl kwa">if self</span> &lt; <span class="hl num">2</span> <span class="hl kwa">then return self</span>
      <span class="hl kwa">return</span> <span class="hl opt">(</span><span class="hl kwa">self</span> <span class="hl opt">-</span> <span class="hl num">1</span><span class="hl opt">).</span>fib <span class="hl opt">+ (</span><span class="hl kwa">self</span> <span class="hl opt">-</span> <span class="hl num">2</span><span class="hl opt">).</span>fib
   <span class="hl kwa">end</span>
<span class="hl kwa">end</span>

print <span class="hl num">6</span><span class="hl opt">.</span>fib <span class="hl slc"># 8</span>
</pre>

Refinement is akin to

* Aspect-Oriented Programming,

  but without weaving issues.

* Monkey-patching,

  but statically checked.


In a refinement of a method, the previous definition is accessible with the `super` keyword.
This allows refiners to add additional behavior before and/or after the original behavior, or change it completely.

For instance, the core method `run` controls the main execution of a program.
It is often refined to add additional behavior before or after the main program. 

As with classes, the keyword `redef`

<pre class="hl"><span class="hl kwa">redef fun</span> run
<span class="hl kwa">do</span>
	print <span class="hl str">&quot;Start program&quot;</span>
	<span class="hl kwa">super</span>
	print <span class="hl str">&quot;End program&quot;</span>
<span class="hl kwa">end</span>

print <span class="hl str">&quot;Hello, World&quot;</span>
</pre>

Will output

	Start program
	Hello, World!
	End program


By default `super` will reuse all the original parameters, you can provide new ones anyway.
The types of the parameters and the return type are 

<pre class="hl"><span class="hl kwa">redef fun</span> print<span class="hl opt">(</span>value<span class="hl opt">)</span>
<span class="hl kwa">do</span>
	<span class="hl kwa">super</span> <span class="hl str">&quot;The Emperor says ``</span><span class="hl esc">{value}</span><span class="hl str">''.&quot;</span>
<span class="hl kwa">end</span>

print <span class="hl str">&quot;Hello, World&quot;</span>
</pre>

## Mission

* Difficulty: easy

In order to encrypt future communication, refine the `print` method to print anything in ROT13.

Hint1: do not infinitely recurse

Hint2: the module `crypto` provides a `rot` method that can be applied on strings.

### Template to Use

<pre class="hl"><span class="hl kwa">module</span> crypto13

<span class="hl kwa">import</span> crypto

<span class="hl kwa">redef fun</span> print<span class="hl opt">(</span>value<span class="hl opt">)</span>
<span class="hl kwa">do</span>
	<span class="hl kwa">var</span> text <span class="hl opt">=</span> value<span class="hl opt">.</span>to_s
	<span class="hl slc"># CODE HERE</span>
<span class="hl kwa">end</span>

print <span class="hl str">&quot;Hello, World!&quot;</span>
print <span class="hl str">&quot;Goodbye, World!&quot;</span>
</pre>

### Expected Output

	Uryyb, Jbeyq!
	Tbbqolr, Jbeyq!
