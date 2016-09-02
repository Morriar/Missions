all: test_pep test_nitc curl_me

.PHONY: test_pep
test_pep:
	nitc test_pep.nit
	cd .. && tests/test_pep

.PHONY: test_nitc
test_nitc:
	nitc test_nitc.nit
	cd .. && tests/test_nitc

.PHONY: curl_me
curl_me:
	${MAKE} -C .. populate
	./curl_me.sh
