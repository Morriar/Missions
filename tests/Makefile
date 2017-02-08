all: nitunit curl_me

.PHONY: nitunit
nitunit:
	cd .. && nitunit tests/

.PHONY: curl_me
curl_me:
	${MAKE} -C .. populate
	./curl_me.sh
