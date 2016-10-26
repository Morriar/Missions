# Control of Control Structures

`break` and `continue` can be used to control the exit path from loops.

<pre class="hl"><span class="hl kwa">for</span> i <span class="hl kwa">in</span> <span class="hl opt">[</span><span class="hl num">0</span><span class="hl opt">.</span><span class="hl num">.50</span><span class="hl opt">[</span> <span class="hl kwa">do</span>
	<span class="hl kwa">if</span> i <span class="hl opt">==</span> <span class="hl num">2</span> <span class="hl kwa">then continue</span>
	<span class="hl kwa">if</span> i <span class="hl opt">==</span> <span class="hl num">5</span> <span class="hl kwa">then break</span>
	print i
<span class="hl kwa">end</span>
<span class="hl slc"># output 0 1 3 4</span>
</pre>

Two other special control structures are the `do` and the `loop`.

`do` is mainly used to scope local variables. It is also used to bound a `break`.

<pre class="hl"><span class="hl kwa">do</span>
	<span class="hl kwa">if</span> level &gt; <span class="hl num">9000</span> <span class="hl kwa">then break</span> <span class="hl slc"># exit the block</span>
	print <span class="hl str">&quot;It's over 9000!!&quot;</span>
	<span class="hl kwa">if not</span> opponent<span class="hl opt">.</span>is_android <span class="hl kwa">then break</span> <span class="hl slc"># exit the block</span>
	print <span class="hl str">&quot;Big Bang Attack&quot;</span>
<span class="hl kwa">end</span>
</pre>

`loop` is used as a infinite loop. It usually requires some additional explicit `break` to control the exit.
It is used to implement `do while/until` loops or `while` loops with a complex exit condition.

<pre class="hl"><span class="hl kwa">var</span> nb <span class="hl opt">=</span> <span class="hl num">0</span>
<span class="hl kwa">loop</span>
	<span class="hl kwa">var</span> line <span class="hl opt">=</span> gets
	<span class="hl kwa">if</span> line <span class="hl opt">==</span> <span class="hl str">&quot;&quot;</span> <span class="hl kwa">then break</span>
	nb <span class="hl opt">+=</span> <span class="hl num">1</span>
<span class="hl kwa">end</span>
print <span class="hl str">&quot;There was</span> <span class="hl esc">{nb}</span> <span class="hl str">line(s).&quot;</span>
</pre>

## Mission

* Difficulty: medium

Finish the program that tests the primality of some numbers.

### Template to Use

<pre class="hl"><span class="hl kwa">module</span> prime

<span class="hl kwa">var</span> limit <span class="hl opt">=</span> <span class="hl num">20</span>

<span class="hl kwa">for</span> i <span class="hl kwa">in</span> <span class="hl opt">[</span><span class="hl num">2</span><span class="hl opt">..</span>limit<span class="hl opt">]</span> <span class="hl kwa">do</span>
	<span class="hl kwa">for</span> j <span class="hl kwa">in</span> <span class="hl opt">[</span><span class="hl num">2</span><span class="hl opt">..</span>i<span class="hl opt">[</span> <span class="hl kwa">do</span>
		<span class="hl kwa">if</span> i <span class="hl opt">%</span> j <span class="hl opt">==</span> <span class="hl num">0</span> <span class="hl kwa">then</span>
<span class="hl slc"># CHANGE BELOW</span>
<span class="hl opt">...</span>
print <span class="hl str">&quot;</span><span class="hl esc">{i}</span> <span class="hl str">is not prime.&quot;</span>
<span class="hl opt">...</span>
print <span class="hl str">&quot;</span><span class="hl esc">{i}</span> <span class="hl str">is prime.&quot;</span>
<span class="hl opt">...</span>
<span class="hl slc"># CHANGE ABOVE</span>
</pre>

### Expected Output

	2 is prime.
	3 is prime.
	4 is not prime.
	5 is prime.
	6 is not prime.
	7 is prime.
	8 is not prime.
	9 is not prime.
	10 is not prime.
	11 is prime.
	12 is not prime.
	13 is prime.
	14 is not prime.
	15 is not prime.
	16 is not prime.
	17 is prime.
	18 is not prime.
	19 is prime.
	20 is not prime.
