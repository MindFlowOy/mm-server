# as this is first rule, it is run atomatically when just 'make' called

list:
	@echo 'Please, use make with some of available targets: compile, watch, run[-dev | -prod], clean, test [-cov | -cov-html], release[-patch | -minor | -major], publish, deploy'
.PHONY: list


# Compile coffee script source and target
BIN = ./node_modules/.bin

SRV_SRC=$(shell find ./src -name "*.coffee")
SRV_LIB = $(patsubst ./src/%.coffee, ./lib/%.js, $(SRV_SRC))

TEST_SRC=$(shell find ./test/src -name "*.coffee")
TEST_LIB = $(patsubst ./test/src/%.coffee, ./test/lib/%.js, $(TEST_SRC))


debug:
	@echo $(SRV_SRC)


lib/%.js: src/%.coffee
	@echo "Coffee $< -- $@"
	@coffee -c -o $(@D) $<

test/lib/%.js: test/src/%.coffee
	@echo "Coffee $< -- $@"
	@coffee -c -o $(@D) $<

compile: $(SRV_LIB)


#------- Watch file changes -------
 watch:
	#watch -i 500ms $(MAKE) compile
	watch -q -i 500ms $(MAKE) compile
.PHONY: watch


# Run targets
#------- Run dev -------
run-dev: compile
	nodemon -w ./src ./src/index.coffee
.PHONY: run

#------- Run prod -------
run-prod: compile
	NODE_ENV='production' node index.js
.PHONY: run-prod

#------- Clean -------
clean:
	@rm -f ./lib/*.*

.PHONY: clean

#------- Test  -------
test: $(TEST_LIB) $(SRV_LIB)
	node_modules/lab/bin/lab

test-cov: $(TEST_LIB) $(SRV_LIB)
	node node_modules/lab/bin/lab -r threshold -t 100

test-cov-html: $(TEST_LIB) $(SRV_LIB)
	node node_modules/lab/bin/lab -r html -o coverage.html

.PHONY: test test-cov test-cov-html


#------- Release -------
define release
 	VERSION=`node -pe "require('./package.json').version"` && \
	NEXT_VERSION=`node -pe "require('semver').inc(\"$$VERSION\", '$(1)')"` && \
	node -e "\
	var j = require('./package.json');\
	j.version = \"$$NEXT_VERSION\";\
	var s = JSON.stringify(j, null, 2);\
	require('fs').writeFileSync('./package.json', s);" && \
	@echo "Commit $$NEXT_VERSION"
	#git commit -m "release $$NEXT_VERSION" -- package.json && \
 	#git tag "$$NEXT_VERSION" -m "release $$NEXT_VERSION"
endef

release-patch: compile test
	@$(call release,patch)

release-minor: compile test
	@$(call release,minor)

release-major: compile test
	@$(call release,major)

#------- Publish -------
publish:
	git push --tags origin HEAD:master
	#npm publish

#------- Deploy -------
deploy:
	git push heroku master
.PHONY: deploy

.PHONY: release-patch release-minor release-major publish
