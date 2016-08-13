# Final Mission

* Difficulty: advanced

Your mission is to combine your `caca` library and your `logolas` parser to render a logolas vectorial image on a terminal.

The `caca` library is

<!--~~~nit
module caca is pkgconfig

`{
#include <caca.h>
`}

extern class CacaCanvas `{ caca_canvas_t* `}
	fun put(text: String, x, y: Int) do native_put(text.to_cstring, x, y)
	fun native_put(text: NativeString, x, y: Int) `{  caca_put_str(self, x, y, text); `}
	fun draw_line(x1, y1, x2, y2: Int) `{ caca_draw_thin_line (self, x1, y1, x2, y2); `}
	fun width: Int `{ return caca_get_canvas_width(self); `}
	fun height: Int `{ return caca_get_canvas_height(self); `}
end

extern class CacaDisplay `{ caca_display_t* `}
	new `{ return caca_create_display(NULL); `}

	fun canvas: CacaCanvas `{ return caca_get_canvas(self); `}

	fun refresh `{ caca_refresh_display(self); `}

	fun quit `{
		caca_event_t ev;
		caca_get_event(self, CACA_EVENT_KEY_PRESS, &ev, -1);
		caca_free_display(self);
	`}
end
~~~-->

<pre class="hl"><span class="hl kwa">module</span> caca <span class="hl kwa">is</span> pkgconfig

<span class="hl str">`{</span>
<span class="hl str">#include &lt;caca.h</span>
<span class="hl str">`</span><span class="hl opt">}</span>

<span class="hl kwa">extern class</span> <span class="hl kwb">CacaCanvas</span> <span class="hl str">`</span><span class="hl esc">{ caca_canvas_t* `}</span>
<span class="hl str">	fun put(text: String, x, y: Int) do native_put(text.to_cstring, x, y)</span>
<span class="hl str">	fun native_put(text: NativeString, x, y: Int) `</span><span class="hl esc">{  caca_put_str(self, x, y, text); `}</span>
	<span class="hl kwa">fun</span> draw_line<span class="hl opt">(</span>x1<span class="hl opt">,</span> y1<span class="hl opt">,</span> x2<span class="hl opt">,</span> y2<span class="hl opt">:</span> <span class="hl kwb">Int</span><span class="hl opt">)</span> <span class="hl str">`</span><span class="hl esc">{ caca_draw_thin_line (self, x1, y1, x2, y2); `}</span>
<span class="hl str">	fun width: Int `</span><span class="hl esc">{ return caca_get_canvas_width(self); `}</span>
	<span class="hl kwa">fun</span> height<span class="hl opt">:</span> <span class="hl kwb">Int</span> <span class="hl str">`</span><span class="hl esc">{ return caca_get_canvas_height(self); `}</span>
<span class="hl str">end</span>
<span class="hl str"></span>
<span class="hl str">extern class CacaDisplay `</span><span class="hl esc">{ caca_display_t* `}</span>
	<span class="hl kwa">new</span> <span class="hl str">`</span><span class="hl esc">{ return caca_create_display(NULL); `}</span>
<span class="hl str"></span>
<span class="hl str">	fun canvas: CacaCanvas `</span><span class="hl esc">{ return caca_get_canvas(self); `}</span>

	<span class="hl kwa">fun</span> refresh <span class="hl str">`</span><span class="hl esc">{ caca_refresh_display(self); `}</span>
<span class="hl str"></span>
<span class="hl str">	fun quit `</span><span class="hl opt">{</span>
		caca_event_t ev<span class="hl opt">;</span>
		caca_get_event<span class="hl opt">(</span><span class="hl kwa">self</span><span class="hl opt">,</span> <span class="hl kwb">CACA_EVENT_KEY_PRESS</span><span class="hl opt">, &amp;</span>ev<span class="hl opt">, -</span><span class="hl num">1</span><span class="hl opt">);</span>
		caca_free_display<span class="hl opt">(</span><span class="hl kwa">self</span><span class="hl opt">);</span>
	<span class="hl str">`}</span>
<span class="hl str">end</span>
</pre>

Implement a program that takes a logolas file as an argument to draw things.

Note that the atùin (the cursor) should start at the middle of the canvas.

## Template To Use

<!--~~~nit
module logolas_caca

import logolas_parser 
import logolas_lexer
import caca

# CODE HERE
~~~-->

<pre class="hl"><span class="hl kwa">module</span> logolas_caca

<span class="hl kwa">import</span> logolas_parser 
<span class="hl kwa">import</span> logolas_lexer
<span class="hl kwa">import</span> caca

<span class="hl slc"># CODE HERE</span>
</pre>

## Expected Result

    $ ./logolas_caca maenas.logolas
    # display an elegant and abstract L letter
    $ ./logolas_caca elen.logolas
    # show a glowing and inspiring star
    $ ./logolas_caca bar.logolas
    # renders a peaceful and warm house
