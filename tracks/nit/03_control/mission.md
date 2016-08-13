# Control structures and conditions

Usual control structures, like conditions and loops, are available.

Most of them exist in two flavors: one-liner and multi-line.

The one-liner flavor needs a single statement just after the control.

<pre class="hl"><span class="hl kwa">if</span> level &gt; <span class="hl num">9000</span> <span class="hl kwa">then</span> print <span class="hl str">&quot;It's over 9000!!&quot;</span>
</pre>

The multi-line flavor has a line-return after the control but requires an `end` keyword.

<pre class="hl"><span class="hl kwa">if</span> level &gt; <span class="hl num">9000</span> <span class="hl kwa">then</span>
	print <span class="hl str">&quot;It's over 9000!!&quot;</span>
	print <span class="hl str">&quot;- What! Nine thousand!&quot;</span>
<span class="hl kwa">end</span>
</pre>

The `if` control accepts an optional `else` block.

<pre class="hl"><span class="hl kwa">if</span> level &gt; <span class="hl num">9000</span> <span class="hl kwa">then</span>
	print <span class="hl str">&quot;It's over 9000!!&quot;</span>
<span class="hl kwa">else if</span> level &gt; <span class="hl num">1000</span> <span class="hl kwa">then</span>
	print <span class="hl str">&quot;It's over 1000...&quot;</span>
<span class="hl kwa">else</span>
	print <span class="hl str">&quot;It's not impressive.&quot;</span>
<span class="hl kwa">end</span>
</pre>

`while` loops are also available:

<pre class="hl"><span class="hl kwa">var</span> i <span class="hl opt">=</span> <span class="hl num">999</span>
<span class="hl kwa">while</span> i &gt; <span class="hl num">1</span> <span class="hl kwa">do</span>
	print <span class="hl str">&quot;</span><span class="hl esc">{i}</span> <span class="hl str">bottles on the wall...&quot;</span>
	i <span class="hl opt">-=</span> <span class="hl num">1</span>
<span class="hl kwa">end</span>
print <span class="hl str">&quot;1 last bottle on the wall...&quot;</span>
</pre>

`for` is an improved `while` that iterates on collections.
They will be shown in a later mission, for the moment, we will use them to iterate on ranges of integers.

<pre class="hl"><span class="hl kwa">for</span> i <span class="hl kwa">in</span> <span class="hl opt">[</span><span class="hl num">0</span><span class="hl opt">.</span><span class="hl num">.5</span><span class="hl opt">[</span> <span class="hl kwa">do</span> print i <span class="hl slc"># 0 1 2 3 4 (5 is excluded)</span>
</pre>

## Mission

* Difficulty: medium

Write a loop that computes the first Fibonacci numbers below a given limit.

Confidential information: fib(0) = 0; fib(1) = 1; fib(n) = fib(n-1) + fib(n-2)

### Template to Use

<pre class="hl"><span class="hl kwa">module</span> fibonacci

<span class="hl kwa">var</span> limit <span class="hl opt">=</span> <span class="hl num">500</span>

<span class="hl kwa">var</span> prev <span class="hl opt">=</span> <span class="hl num">0</span>
<span class="hl kwa">var</span> n <span class="hl opt">=</span> <span class="hl num">1</span>

<span class="hl slc"># CODE HERE</span>
</pre>

### Expected Output

	1
	1
	2
	3
	5
	8
	13
	21
	34
	55
	89
	144
	233
	377
