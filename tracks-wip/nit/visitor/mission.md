# Visitor Design Pattern

The well-known Visitor Design Pattern allows for dissociation between the traversal of an heterogeneous data structure and the various computations done on this data structure.

The standard way is to engineer the visited classes with a special `accept` callback that will invoke a specific `visit_*` method of an abstract Visitor.
Adding new behaviours and computations is done in specific subclasses of the abstract visitor. 

This standard way has some issues:

* the visitor has to be developed with the data-classes
* the visitor is complex with a lot of methods
* the signature of the `visit_*` methods has to be decided once for all (there is various ways to mitigate the issue dependently on the language)
* there is a specific and independent method `visit_*` method for each concrete data-class, without a nice OO way to factorize them
* most of the implemented behavior is the sole responsibility of the data-class and implementing them in a concrete visitor is not optimal (bad responsibility assignment, bad coupling)

Concern-oriented programming and class refinement in Nit help solve most of these issues.

So, let us consider the following classes used to represent a boolean expression.

<!--
~~~nit
# Simple Boolean expressions
module bool_expr

# A boolean expression
abstract class BoolExpr
end

# A boolean binary operation
abstract class BoolBinOp
	super BoolExpr
	# The left operand
	var left: BoolExpr
	# The right operand
	var right: BoolExpr
end

# A boolean conjunction
class BoolAnd
	super BoolBinOp
end

# A boolean disjunction
class BoolOr
	super BoolBinOp
end

# A boolean negation
class BoolNot
	super BoolExpr
	# the negated boolean
	var expr: BoolExpr
end

# A true boolean value
class BoolTrue
	super BoolExpr
end

# A false boolean value
class BoolFalse
	super BoolExpr
end
~~~
-->

<pre class="hl"><span class="hl slc"># Simple Boolean expressions</span>
<span class="hl kwa">module</span> bool_expr

<span class="hl slc"># A boolean expression</span>
<span class="hl kwa">abstract class</span> <span class="hl kwb">BoolExpr</span>
<span class="hl kwa">end</span>

<span class="hl slc"># A boolean binary operation</span>
<span class="hl kwa">abstract class</span> <span class="hl kwb">BoolBinOp</span>
	<span class="hl kwa">super</span> <span class="hl kwb">BoolExpr</span>
	<span class="hl slc"># The left operand</span>
	<span class="hl kwa">var</span> left<span class="hl opt">:</span> <span class="hl kwb">BoolExpr</span>
	<span class="hl slc"># The right operand</span>
	<span class="hl kwa">var</span> right<span class="hl opt">:</span> <span class="hl kwb">BoolExpr</span>
<span class="hl kwa">end</span>

<span class="hl slc"># A boolean conjunction</span>
<span class="hl kwa">class</span> <span class="hl kwb">BoolAnd</span>
	<span class="hl kwa">super</span> <span class="hl kwb">BoolBinOp</span>
<span class="hl kwa">end</span>

<span class="hl slc"># A boolean disjunction</span>
<span class="hl kwa">class</span> <span class="hl kwb">BoolOr</span>
	<span class="hl kwa">super</span> <span class="hl kwb">BoolBinOp</span>
<span class="hl kwa">end</span>

<span class="hl slc"># A boolean negation</span>
<span class="hl kwa">class</span> <span class="hl kwb">BoolNot</span>
	<span class="hl kwa">super</span> <span class="hl kwb">BoolExpr</span>
	<span class="hl slc"># the negated boolean</span>
	<span class="hl kwa">var</span> expr<span class="hl opt">:</span> <span class="hl kwb">BoolExpr</span>
<span class="hl kwa">end</span>

<span class="hl slc"># A true boolean value</span>
<span class="hl kwa">class</span> <span class="hl kwb">BoolTrue</span>
	<span class="hl kwa">super</span> <span class="hl kwb">BoolExpr</span>
<span class="hl kwa">end</span>

<span class="hl slc"># A false boolean value</span>
<span class="hl kwa">class</span> <span class="hl kwb">BoolFalse</span>
	<span class="hl kwa">super</span> <span class="hl kwb">BoolExpr</span>
<span class="hl kwa">end</span>
</pre>

Let's add a visitor, by refinement of the existing classes in a new and independent module.

<!--
~~~nit
# Visit the simple Boolean expressions
module bool_visitor

import bool_expr

# An abstract visitor.
#
# Please implement `visit` for specific behavior and computation.
abstract class BoolVisitor
	# Visit an
	fun visit(expr: BoolExpr) is abstract
end

redef class BoolExpr
	# Call `visit` in order on each sub-expressions (if any)
	fun visit_children(v: BoolVisitor) do end
end

redef class BoolBinOp
	redef fun visit_children(v)
	do
		v.visit(left)
		v.visit(right)
	end
end

redef class BoolNot
	redef fun visit_children(v)
	do
		v.visit(expr)
	end
end
~~~-->

<pre class="hl"><span class="hl slc"># Visit the simple Boolean expressions</span>
<span class="hl kwa">module</span> bool_visitor

<span class="hl kwa">import</span> bool_expr

<span class="hl slc"># An abstract visitor.</span>
<span class="hl slc">#</span>
<span class="hl slc"># Please implement `visit` for specific behavior and computation.</span>
<span class="hl kwa">abstract class</span> <span class="hl kwb">BoolVisitor</span>
	<span class="hl slc"># Visit an</span>
	<span class="hl kwa">fun</span> visit<span class="hl opt">(</span>expr<span class="hl opt">:</span> <span class="hl kwb">BoolExpr</span><span class="hl opt">)</span> <span class="hl kwa">is abstract</span>
<span class="hl kwa">end</span>

<span class="hl kwa">redef class</span> <span class="hl kwb">BoolExpr</span>
	<span class="hl slc"># Call `visit` in order on each sub-expressions (if any)</span>
	<span class="hl kwa">fun</span> visit_children<span class="hl opt">(</span>v<span class="hl opt">:</span> <span class="hl kwb">BoolVisitor</span><span class="hl opt">)</span> <span class="hl kwa">do end</span>
<span class="hl kwa">end</span>

<span class="hl kwa">redef class</span> <span class="hl kwb">BoolBinOp</span>
	<span class="hl kwa">redef fun</span> visit_children<span class="hl opt">(</span>v<span class="hl opt">)</span>
	<span class="hl kwa">do</span>
		v<span class="hl opt">.</span>visit<span class="hl opt">(</span>left<span class="hl opt">)</span>
		v<span class="hl opt">.</span>visit<span class="hl opt">(</span>right<span class="hl opt">)</span>
	<span class="hl kwa">end</span>
<span class="hl kwa">end</span>

<span class="hl kwa">redef class</span> <span class="hl kwb">BoolNot</span>
	<span class="hl kwa">redef fun</span> visit_children<span class="hl opt">(</span>v<span class="hl opt">)</span>
	<span class="hl kwa">do</span>
		v<span class="hl opt">.</span>visit<span class="hl opt">(</span>expr<span class="hl opt">)</span>
	<span class="hl kwa">end</span>
<span class="hl kwa">end</span>
</pre>

You can see that the visitor can be created after the data-classes without altering the original module.

Let's now implement some visitor that counts the number of binary operations in an expression.

<!--
~~~
module bool_counter

import bool_visitor

class BoolCounter
	super BoolVisitor

	fun count(expr: BoolExpr): Int
	do
		cpt = 0
		visit(expr)
		return cpt
	end

	redef fun visit(expr) do
		# Call the specific count code
		expr.accept_count(self)
		# Recursively process the sub-expressions if any
		expr.visit_children(self)
	end

	# Counter of binary operations
	var cpt = 0
end

redef class BoolExpr
	# The specific `counting` behavior.
	private fun accept_count(v: BoolCounter) do end
end

redef class BoolBinOp
	redef fun accept_count(v) do v.cpt += 1
end

var e1 = new BoolOr(new BoolAnd(new BoolTrue, new BoolFalse), new BoolNot(new BoolTrue))
var e2 = new BoolAnd(new BoolNot(e1), new BoolTrue)

var v = new BoolCounter
print v.count(e1) # 2
print v.count(e2) # 3
~~~-->

<pre class="hl"><span class="hl kwa">module</span> bool_counter

<span class="hl kwa">import</span> bool_visitor

<span class="hl kwa">class</span> <span class="hl kwb">BoolCounter</span>
	<span class="hl kwa">super</span> <span class="hl kwb">BoolVisitor</span>

	<span class="hl kwa">fun</span> count<span class="hl opt">(</span>expr<span class="hl opt">:</span> <span class="hl kwb">BoolExpr</span><span class="hl opt">):</span> <span class="hl kwb">Int</span>
	<span class="hl kwa">do</span>
		cpt <span class="hl opt">=</span> <span class="hl num">0</span>
		visit<span class="hl opt">(</span>expr<span class="hl opt">)</span>
		<span class="hl kwa">return</span> cpt
	<span class="hl kwa">end</span>

	<span class="hl kwa">redef fun</span> visit<span class="hl opt">(</span>expr<span class="hl opt">)</span> <span class="hl kwa">do</span>
		<span class="hl slc"># Call the specific count code</span>
		expr<span class="hl opt">.</span>accept_count<span class="hl opt">(</span><span class="hl kwa">self</span><span class="hl opt">)</span>
		<span class="hl slc"># Recursively process the sub-expressions if any</span>
		expr<span class="hl opt">.</span>visit_children<span class="hl opt">(</span><span class="hl kwa">self</span><span class="hl opt">)</span>
	<span class="hl kwa">end</span>

	<span class="hl slc"># Counter of binary operations</span>
	<span class="hl kwa">var</span> cpt <span class="hl opt">=</span> <span class="hl num">0</span>
<span class="hl kwa">end</span>

<span class="hl kwa">redef class</span> <span class="hl kwb">BoolExpr</span>
	<span class="hl slc"># The specific `counting` behavior.</span>
	<span class="hl kwa">private fun</span> accept_count<span class="hl opt">(</span>v<span class="hl opt">:</span> <span class="hl kwb">BoolCounter</span><span class="hl opt">)</span> <span class="hl kwa">do end</span>
<span class="hl kwa">end</span>

<span class="hl kwa">redef class</span> <span class="hl kwb">BoolBinOp</span>
	<span class="hl kwa">redef fun</span> accept_count<span class="hl opt">(</span>v<span class="hl opt">)</span> <span class="hl kwa">do</span> v<span class="hl opt">.</span>cpt <span class="hl opt">+=</span> <span class="hl num">1</span>
<span class="hl kwa">end</span>

<span class="hl kwa">var</span> e1 <span class="hl opt">=</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolOr</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolAnd</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolTrue</span><span class="hl opt">,</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolFalse</span><span class="hl opt">),</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolNot</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolTrue</span><span class="hl opt">))</span>
<span class="hl kwa">var</span> e2 <span class="hl opt">=</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolAnd</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolNot</span><span class="hl opt">(</span>e1<span class="hl opt">),</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolTrue</span><span class="hl opt">)</span>

<span class="hl kwa">var</span> v <span class="hl opt">=</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolCounter</span>
print v<span class="hl opt">.</span>count<span class="hl opt">(</span>e1<span class="hl opt">)</span> <span class="hl slc"># 2</span>
print v<span class="hl opt">.</span>count<span class="hl opt">(</span>e2<span class="hl opt">)</span> <span class="hl slc"># 3</span>
</pre>

## Mission

* Difficulty: medium

Implement an evaluator that can visit and transform one of our Boolean expressions to a standard Bool value `true` or `false`.

### Template to Use

<!--
~~~nit
module bool_eval

import bool_visitor

# CODE HERE

var e1 = new BoolOr(new BoolAnd(new BoolTrue, new BoolFalse), new BoolNot(new BoolTrue))
var e2 = new BoolAnd(new BoolNot(e1), new BoolTrue)

print e1.eval
print e2.eval
~~~-->

<pre class="hl"><span class="hl kwa">module</span> bool_eval

<span class="hl kwa">import</span> bool_visitor

<span class="hl slc"># CODE HERE</span>

<span class="hl kwa">var</span> e1 <span class="hl opt">=</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolOr</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolAnd</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolTrue</span><span class="hl opt">,</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolFalse</span><span class="hl opt">),</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolNot</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolTrue</span><span class="hl opt">))</span>
<span class="hl kwa">var</span> e2 <span class="hl opt">=</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolAnd</span><span class="hl opt">(</span><span class="hl kwa">new</span> <span class="hl kwb">BoolNot</span><span class="hl opt">(</span>e1<span class="hl opt">),</span> <span class="hl kwa">new</span> <span class="hl kwb">BoolTrue</span><span class="hl opt">)</span>

print e1<span class="hl opt">.</span>eval
print e2<span class="hl opt">.</span>eval
</pre>

### Expected Output

    false
    true
