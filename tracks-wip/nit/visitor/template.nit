module bool_eval

import bool_visitor

# CODE HERE

var e1 = new BoolOr(new BoolAnd(new BoolTrue, new BoolFalse), new BoolNot(new BoolTrue))
var e2 = new BoolAnd(new BoolNot(e1), new BoolTrue)

print e1.eval
print e2.eval
