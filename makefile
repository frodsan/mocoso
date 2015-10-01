default: test

install:
	@cat .gems | xargs gem install

test:
	@cutest ./test/*.rb

.PHONY: test
