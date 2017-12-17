AWS_BUCKET = voytek.solutions
AWS_PROFILE ?= vs
AWS_REGION ?= eu-west-1
DIR_OUT ?= ./out
PWD = $(shell pwd)

PATH := .venv/bin:$(shell printenv PATH)
SHELL := env PATH=$(PATH) /bin/bash

## Initialize project
init: node_modules .venv

## Watch files for changes and rebuild
watch:
	while sleep 1; do \
		find Makefile .jshintrc find scripts/ site/ templates/ styles/ \
		| entr -d make lint build; \
	done

deploy: deploy.mydevil

## Deployes to mydevil servers
deploy.mydevil: clean build
	scp -r out/* woledzki@s2.mydevil.net:~/domains/voytek.solutions/public_html/

## Deploys to AWS
deploy.aws: build gzip
	export AWS_DEFAULT_PROFILE=$(AWS_PROFILE)
	export AWS_DEFAULT_REGION=$(AWS_REGION)
	aws s3 sync \
		--acl 'public-read' \
		--exclude '*.*' \
		--include '*.css' \
		--content-type 'text/css' \
		--cache-control 'max-age=604800' \
		--content-encoding 'gzip' \
		out/ s3://$(AWS_BUCKET)/
	aws s3 sync \
		--acl 'public-read' \
		--exclude '*.*' \
		--include '*.png' --include '*.jpg' \
		--cache-control 'max-age=604800' \
		--content-encoding 'gzip' \
		out/ s3://$(AWS_BUCKET)/
	aws s3 sync \
		--acl 'public-read' \
		--exclude '*.*' \
		--include '*.html' \
		--content-type 'text/html' \
		--cache-control 'max-age=604800' \
		--content-encoding 'gzip' \
		out/ s3://$(AWS_BUCKET)/
	aws s3 sync \
		--acl 'public-read' \
		--exclude '*.*' \
		--include 'wojtek.oledzki.asc' \
		--cache-control 'max-age=604800' \
		out/ s3://$(AWS_BUCKET)/

## Build site
build: build_css build_js build_img build_html $(DIR_OUT)/cv.pdf
	cp wojtek.oledzki.asc $(DIR_OUT)/wojtek.oledzki.asc
	cp site/index.php $(DIR_OUT)/index.php
	#cp ~/Dropbox/Public/Oledzki\ Wojciech\ CV.pdf $(DIR_OUT)/cv.pdf

## Start site locally on http://localhost:8888
serve:
	cd $(DIR_OUT) && php -S localhost:8888

## Builds static HTML
build_html: displayService.phar
	DS_HOSTDIR=$(PWD)/ \
	DS_ENV=prod \
	php displayService.phar \
		ds:generate \
		--source='/' \
		--output='$(DIR_OUT)'

## Copies images to /static
build_img:
	rm -rf $(DIR_OUT)/static/img
	mkdir -p $(DIR_OUT)/static/img/clients
	find img \( -iname '*.jpg' -o -iname '*.png' \) \
		-exec cp {} $(DIR_OUT)/static/{} \;

## Builds CSS
build_css:
	rm -rf out/static/styles/css
	mkdir -p out/static/styles/css
	rm -rf out/static/styles/gfx
	cp -R styles/gfx out/static/styles/
	$${GEM_HOME}/bin/sass \
		--style compressed \
		styles/sass/main.scss \
		$(DIR_OUT)/static/styles/css/main.css
	$${GEM_HOME}/bin/sass \
		--style compressed \
		styles/sass/inline.scss \
		$(DIR_OUT)/static/styles/css/inline.css

## Build JS for the site
build_js:
	rm -f scripts/b2c/views/*.js
	cd scripts/b2c && node process_views.js
	rm -rf $(DIR_OUT)/static/scripts
	./node_modules/.bin/webpack

## Lint source files
lint:
	./node_modules/.bin/jscs \
		scripts/b2c/src \
		scripts/b2c/test/spec
	./node_modules/.bin/jshint \
		scripts/b2c/src \
		scripts/b2c/test/spec

## Gzip content in 'DIR_OUT' folder
gzip:
	find $(DIR_OUT) \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' -o -iname '*.png' -o -iname '*.jpg' \) \
		-exec gzip -9 -n {} \; \
		-exec mv {}.gz {} \;

## Cleans generated HTML and CSS
clean:
	mkdir -p out
	rm -rf out/*

# install local venv with
.venv:
	@which virtualenv > /dev/null || (\
		echo "please install virtualenv: http://docs.python-guide.org/en/latest/dev/virtualenvs/" \
		&& exit 1 \
	)
	virtualenv .venv
	.venv/bin/pip install -U "pip<9.0"
	.venv/bin/pip install pyopenssl urllib3[secure] requests[security]
	.venv/bin/pip install -r requirements.txt --ignore-installed
	virtualenv --relocatable .venv

# install npm requirements
node_modules:
	npm install

$(DIR_OUT)/cv.pdf:
	curl -Lo $(DIR_OUT)/cv.pdf "https://www.dropbox.com/s/5bhok74pfnhwah2/Oledzki Wojciech CV.pdf"

displayService.phar:
	curl -LO http://get.hoborglabs.com/displayService.phar

## Prints this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
