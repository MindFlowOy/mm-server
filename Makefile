# Compile coffee script
BIN = ./node_modules/.bin
SRV_SRC=$(shell find ./src -name "*.coffee")
SRV_LIB = $(patsubst ./src/%.coffee, ./lib/%.js, $(SRV_SRC))


debug:
	@echo $(COFFEE)

lib/%.js: src/%.coffee
	@echo "Coffee $< -- $@"
	@coffee -c -o $(@D) $<

compile: $(SRV_LIB)


# Watch file changes
 watch:
	#watch -i 500ms $(MAKE) compile
	watch -q -i 500ms $(MAKE) compile
.PHONY: watch


# Run targets
run: compile
	node ./lib/index.js
PHONY: run


# Clean
clean:
	@rm -f ./lib/*.*

PHONY: clean

# Test targets
 test:
	@node node_modules/lab/bin/lab

test-cov:
	@node node_modules/lab/bin/lab -r threshold -t 100

test-cov-html:
	@node node_modules/lab/bin/lab -r html -o coverage.html

.PHONY: test test-cov test-cov-html
