# Values and Types

Nit is a fully Object-Oriented language.
It means that any value is an object (even primitive values like integers).

Nit is also Class-Oriented.
It means that any object is an instance of a class.

Nit is also fully statically typed.
It means that any expression, local variable, parameter, return value and attribute of instance has a static type that documents and controls what kind of values are expected.

Local variables are used to hold values.
To use variables you must declare them (with the `var` keyword).
You can assign them (with `=`) and use them in expressions.

<pre class="hl"><span class="hl kwa">var</span> i
i <span class="hl opt">=</span> <span class="hl num">5</span>
print i <span class="hl opt">+</span> <span class="hl num">1</span> <span class="hl slc"># Outputs 6</span>
</pre>

As you can see, although Nit is statically typed, the language does not force the programmer to annotate most static types.
The static type system automatically associates `i` with the static type `Int`, the static type is then used to check that `+ 1` is legal on `i`.

For instance, the type system will prevent a tired programmer to add Booleans:

<pre class="hl"><span class="hl kwa">var</span> j <span class="hl opt">=</span> <span class="hl kwa">true</span>
print j <span class="hl opt">+</span> <span class="hl num">1</span>
<span class="hl slc">#       ^</span>
<span class="hl slc"># Compilation Error: method `+` does not exists in `Bool`.</span>
</pre>

Beside integers (`Int`) and booleans (`Bool`), the core library defines a lot of other classes like `String` and `Float`.

Static types are mainly used to ensure that the operations used on the values are legal for any execution of the libraries or the program.

Common operations are available on the types defined by the core library. For instance:

<pre class="hl"><span class="hl kwa">var</span> three <span class="hl opt">=</span> <span class="hl num">1</span> <span class="hl opt">+</span> <span class="hl num">2</span>
<span class="hl kwa">var</span> hw <span class="hl opt">=</span> <span class="hl str">&quot;hello&quot;</span> <span class="hl opt">+</span> <span class="hl str">&quot; &quot;</span> <span class="hl opt">+</span> <span class="hl str">&quot;world&quot;</span>
</pre>

The type system ensures that operations are valid on the operands.
For instance mixing types does not always work:

<pre class="hl">print three <span class="hl opt">+</span> hw
<span class="hl slc">#             ^</span>
<span class="hl slc"># Type Error: expected `Int`, got `String`</span>
</pre>

Conversion between types can be achieved with special operations like `to_i`, `to_s`.

Moreover, string expansion is available through the `{}` notation:

<pre class="hl">print <span class="hl str">&quot;one plus one is</span> <span class="hl esc">{1+1}</span><span class="hl str">&quot;</span> <span class="hl slc"># one plus one is 2</span>
print <span class="hl str">&quot;10&quot;</span><span class="hl opt">.</span>to_i <span class="hl opt">+</span> <span class="hl num">10</span> <span class="hl slc"># 20</span>
print <span class="hl num">10</span><span class="hl opt">.</span>to_s <span class="hl opt">+</span> <span class="hl str">&quot;10&quot;</span> <span class="hl slc"># 1010</span>
</pre>

Inside strings, `"` and `{` can be escaped with `\`. Or a triple quoted notation could be used.

<pre class="hl">print <span class="hl str">&quot;\&quot;</span>quote<span class="hl opt"></span><span class="hl str">&quot; and \</span><span class="hl esc">{curly brackets\}</span><span class="hl str">&quot;</span>
print <span class="hl str">&quot;&quot;&quot;&quot;quote&quot; and</span> <span class="hl esc">{curly brackets}</span><span class="hl str">&quot;&quot;&quot;</span>
</pre>

## Mission

* Difficulty: basic

Define two variables, `a_string` and `an_integer` initialized respectively to `"ten"` and `10`.

### Template to Use

<pre class="hl"><span class="hl kwa">module</span> value

<span class="hl slc"># CHANGE BELOW</span>
<span class="hl kwa">var</span> a_string <span class="hl opt">= ?</span>
<span class="hl kwa">var</span> an_integer <span class="hl opt">= ?</span>
<span class="hl slc"># CHANGE ABOVE</span>

print <span class="hl str">&quot;a_string!</span> <span class="hl esc">{a_string + &quot;!&quot;}</span><span class="hl str">&quot;</span>
print <span class="hl str">&quot;an_integer!</span> <span class="hl esc">{an_integer.factorial}</span><span class="hl str">&quot;</span>
</pre>

### Expected Output

	a_string! ten!
	an_integer! 3628800
