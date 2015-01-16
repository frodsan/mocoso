DEFAULT_GOAL := test
.PHONY: test

gem:
	gem build ohm-validations.gemspec

test:
	cutest test/*.rb
