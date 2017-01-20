module prime

var limit = 20

for i in [2..limit] do
	for j in [2..i[ do
		if i % j == 0 then
# CHANGE BELOW
...
print "{i} is not prime."
...
print "{i} is prime."
...
# CHANGE ABOVE
