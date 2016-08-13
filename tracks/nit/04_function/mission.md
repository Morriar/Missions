# Functions

Functions start with the `fun` keyword. They require a name, parameters (if any) and a return type (if any).

<pre class="hl"><span class="hl kwa">fun</span> presentation<span class="hl opt">(</span>name<span class="hl opt">:</span> <span class="hl kwb">String</span><span class="hl opt">,</span> age<span class="hl opt">:</span> <span class="hl kwb">Int</span><span class="hl opt">):</span> <span class="hl kwb">String</span>
<span class="hl kwa">do</span>
	<span class="hl kwa">return</span> <span class="hl str">&quot;Hello, my name is</span> <span class="hl esc">{name}</span> <span class="hl str">and I am</span> <span class="hl esc">{age}</span><span class="hl str">. I live in the Dome and I am an happy Citizen.&quot;</span>
<span class="hl kwa">end</span>

print presentation<span class="hl opt">(</span><span class="hl str">&quot;Alice&quot;</span><span class="hl opt">,</span> <span class="hl num">21</span><span class="hl opt">)</span>
</pre>

## Default Argument Values

Default arguments values rely on the `nullable` information: trailing nulls in a call can be omitted.

<pre class="hl"><span class="hl kwa">fun</span> presentation<span class="hl opt">(</span>name<span class="hl opt">:</span> <span class="hl kwa">nullable</span> <span class="hl kwb">String</span><span class="hl opt">,</span> age<span class="hl opt">:</span> <span class="hl kwa">nullable</span> <span class="hl kwb">Int</span><span class="hl opt">):</span> <span class="hl kwb">String</span>
<span class="hl kwa">do</span>
	<span class="hl kwa">if</span> name <span class="hl opt">==</span> <span class="hl kwa">null then</span> name <span class="hl opt">=</span> <span class="hl str">&quot;Anonymous&quot;</span>
	<span class="hl slc"># Note: Adaptive typing says that `name` is a non-nullable here</span>
	<span class="hl kwa">var</span> res <span class="hl opt">=</span> <span class="hl str">&quot;Hello, my name is</span> <span class="hl esc">{name}</span><span class="hl str">&quot;</span>
	<span class="hl kwa">if</span> age <span class="hl opt">!=</span> <span class="hl kwa">null then</span>
		<span class="hl slc"># Note: Adaptive typing says that `age` is a non-nullable here</span>
		<span class="hl slc"># type adaptation</span>
		res <span class="hl opt">+=</span> <span class="hl str">&quot; and I am</span> <span class="hl esc">{age}</span><span class="hl str">&quot;</span>
	<span class="hl kwa">end</span>
	res <span class="hl opt">+=</span> <span class="hl str">&quot;. I live in the Dome and I am an happy Citizen.&quot;</span>
	<span class="hl kwa">return</span> res
<span class="hl kwa">end</span>
print presentation<span class="hl opt">(</span><span class="hl str">&quot;Alice&quot;</span><span class="hl opt">,</span> <span class="hl num">21</span><span class="hl opt">)</span>
print presentation<span class="hl opt">(</span><span class="hl str">&quot;Bob&quot;</span><span class="hl opt">)</span>
print presentation<span class="hl opt">(</span><span class="hl kwa">null</span><span class="hl opt">,</span> <span class="hl num">99</span><span class="hl opt">)</span>
print presentation
</pre>

## Variadic Function

A parameter can hold a variable number of arguments, its type has to be suffixed by the ellipsis `...`

On the call side, one or more parameters can be given, on the method side, the static type of the parameter is an Array.

<pre class="hl"><span class="hl kwa">fun</span> present_all<span class="hl opt">(</span>names<span class="hl opt">:</span> <span class="hl kwb">String</span><span class="hl opt">...):</span> <span class="hl kwb">String</span>
<span class="hl kwa">do</span>
	<span class="hl kwa">if</span> names<span class="hl opt">.</span>length <span class="hl opt">==</span> <span class="hl num">1</span> <span class="hl kwa">then</span>
		<span class="hl kwa">return</span> presentation<span class="hl opt">(</span>names<span class="hl opt">.</span>first<span class="hl opt">)</span>
	<span class="hl kwa">else</span>
		<span class="hl kwa">return</span> <span class="hl str">&quot;Hello, we are</span> <span class="hl esc">{names.join(&quot;, &quot;)}</span> <span class="hl str">and we are legion.&quot;</span>
	<span class="hl kwa">end</span>
<span class="hl kwa">end</span>
print present_all<span class="hl opt">(</span><span class="hl str">&quot;Alice&quot;</span><span class="hl opt">,</span> <span class="hl str">&quot;Bob&quot;</span><span class="hl opt">,</span> <span class="hl str">&quot;Dylan&quot;</span><span class="hl opt">)</span>
print present_all<span class="hl opt">(</span><span class="hl str">&quot;Eve&quot;</span><span class="hl opt">)</span>
</pre>

## Mission

* Difficulty: medium

Write a function `hanoi` that plays the Towers of Hanoi.

### Template to Use

<pre class="hl"><span class="hl kwa">module</span> hanoi

<span class="hl slc"># CODE HERE</span>

print <span class="hl str">&quot;Test 3 disks&quot;</span>
hanoi<span class="hl opt">(</span><span class="hl num">3</span><span class="hl opt">)</span>

print <span class="hl str">&quot;Test 5 disks&quot;</span>
hanoi<span class="hl opt">(</span><span class="hl num">5</span><span class="hl opt">)</span>
</pre>

### Expected Result

	Test 3 disks
	Move disk from 0 to 1.
	Move disk from 0 to 2.
	Move disk from 1 to 2.
	Move disk from 0 to 1.
	Move disk from 2 to 0.
	Move disk from 2 to 1.
	Move disk from 0 to 1.
	Test 5 disks
	Move disk from 0 to 1.
	Move disk from 0 to 2.
	Move disk from 1 to 2.
	Move disk from 0 to 1.
	Move disk from 2 to 0.
	Move disk from 2 to 1.
	Move disk from 0 to 1.
	Move disk from 0 to 2.
	Move disk from 1 to 2.
	Move disk from 1 to 0.
	Move disk from 2 to 0.
	Move disk from 1 to 2.
	Move disk from 0 to 1.
	Move disk from 0 to 2.
	Move disk from 1 to 2.
	Move disk from 0 to 1.
	Move disk from 2 to 0.
	Move disk from 2 to 1.
	Move disk from 0 to 1.
	Move disk from 2 to 0.
	Move disk from 1 to 2.
	Move disk from 1 to 0.
	Move disk from 2 to 0.
	Move disk from 2 to 1.
	Move disk from 0 to 1.
	Move disk from 0 to 2.
	Move disk from 1 to 2.
	Move disk from 0 to 1.
	Move disk from 2 to 0.
	Move disk from 2 to 1.
	Move disk from 0 to 1.
