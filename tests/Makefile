all: test_pep curl_me

.PHONY: test_pep
test_pep:
	nitc test_pep.nit
	cd .. && tests/test_pep

.PHONY: curl_me
curl_me:
	${MAKE} -C .. populate
	./curl_me.sh
