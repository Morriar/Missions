# Collections and for loops

In Nit there are various kinds of collections.
They are used to manipulate finite groups of objects.

Because Nit is statically typed, the type of the elements of a collection is statically known.

The most common collection is `Array`.

<pre class="hl"><span class="hl kwa">var</span> a <span class="hl opt">= [</span><span class="hl num">2</span><span class="hl opt">,</span> <span class="hl num">3</span><span class="hl opt">,</span> <span class="hl num">5</span><span class="hl opt">]</span>
print a<span class="hl opt">.</span>length <span class="hl slc"># 3</span>
print a<span class="hl opt">.</span>first <span class="hl slc"># 2</span>
print a<span class="hl opt">[</span><span class="hl num">2</span><span class="hl opt">]</span> <span class="hl slc"># 5</span>
</pre>

Array is a mutable data-structure and elements can be added or removed.

<pre class="hl">print a<span class="hl opt">.</span>pop <span class="hl slc"># 5</span>
print a     <span class="hl slc"># [2,3]</span>
a<span class="hl opt">.</span>add <span class="hl num">50</span>
print a     <span class="hl slc"># [2,3,50]</span>
</pre>

Another useful collection is Range. It is used to store intervals.

There are two kind of ranges, closed ones and semi-open ones (we'll just refer to them as open even if it is not mathematically accurate).

<pre class="hl"><span class="hl kwa">var</span> closed <span class="hl opt">= [</span><span class="hl num">10</span><span class="hl opt">.</span><span class="hl num">.15</span><span class="hl opt">]</span>
print closed <span class="hl slc"># [10,11,12,13,14,15]</span>
<span class="hl kwa">var</span> open <span class="hl opt">= [</span><span class="hl num">10</span><span class="hl opt">.</span><span class="hl num">.15</span><span class="hl opt">[</span>
print open <span class="hl slc"># [10,11,12,13,14]</span>
</pre>

The most common operation on collections is to iterate on them.
The `for` control structure does just that.

<pre class="hl"><span class="hl kwa">for</span> i <span class="hl kwa">in</span> <span class="hl opt">[</span><span class="hl num">0</span><span class="hl opt">.</span><span class="hl num">.5</span><span class="hl opt">[</span> <span class="hl kwa">do</span> print i <span class="hl slc"># 0 1 2 3 4</span>
<span class="hl kwa">for</span> i <span class="hl kwa">in</span> <span class="hl opt">[</span><span class="hl num">2</span><span class="hl opt">,</span> <span class="hl num">3</span><span class="hl opt">,</span> <span class="hl num">5</span><span class="hl opt">]</span> <span class="hl kwa">do</span> print i <span class="hl slc"># 2 3 5</span>
</pre>

## Mission

* Difficulty: easy

Write a function that prints the numbers of a collection that are odd and lower than 42.

### Template to Use

<pre class="hl"><span class="hl kwa">module</span> filter

<span class="hl kwa">fun</span> filter<span class="hl opt">(</span>ints<span class="hl opt">:</span> <span class="hl kwb">Collection</span><span class="hl opt">[</span><span class="hl kwb">Int</span><span class="hl opt">])</span>
<span class="hl kwa">do</span>
<span class="hl slc"># CODE HERE</span>
<span class="hl kwa">end</span>

print <span class="hl str">&quot;Test 1&quot;</span>
filter<span class="hl opt">([</span><span class="hl num">1</span><span class="hl opt">,</span><span class="hl num">2</span><span class="hl opt">,</span><span class="hl num">3</span><span class="hl opt">,</span><span class="hl num">41</span><span class="hl opt">,</span><span class="hl num">42</span><span class="hl opt">,</span><span class="hl num">43</span><span class="hl opt">,</span><span class="hl num">9</span><span class="hl opt">])</span>
print <span class="hl str">&quot;Test 2&quot;</span>
filter<span class="hl opt">([</span><span class="hl num">35</span><span class="hl opt">.</span><span class="hl num">.45</span><span class="hl opt">])</span>
</pre>

### Expected Output

	Test 1
	1
	3
	41
	9
	Test 2
	35
	37
	39
	41
