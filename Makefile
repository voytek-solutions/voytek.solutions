AWS_PROFILE?=vs
AWS_REGION?=eu-west-1
AWS_BUCKET=voytek.solutions
PWD=$(shell pwd)
DIR_OUT?=./out

watch:
	while sleep 1; do \
		find Makefile .jshintrc find scripts/ site/ templates/ \
		| entr -d make lint build; \
	done

deploy: deploy_mydevil

## Deployes to mydevil servers
deploy_mydevil: clean build
	scp -r out/* woledzki@s2.mydevil.net:~/domains/voytek.solutions/public_html/

## Deploys to AWS
deploy_aws: build gzip
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

build: build_css build_js build_img build_html
	cp wojtek.oledzki.asc $(DIR_OUT)/wojtek.oledzki.asc
	cp site/index.php $(DIR_OUT)/index.php
	cp ~/Dropbox/Public/Oledzki\ Wojciech\ CV.pdf $(DIR_OUT)/cv.pdf

serve:
	cd $(DIR_OUT) && php -S localhost:8888

## Builds static HTML
build_html:
	DS_HOSTDIR=$(PWD) \
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
	~/.gem/ruby/2.0.0/bin/sass \
		--style compressed \
		styles/sass/main.scss \
		$(DIR_OUT)/static/styles/css/main.css
	~/.gem/ruby/2.0.0/bin/sass \
		--style compressed \
		styles/sass/inline.scss \
		$(DIR_OUT)/static/styles/css/inline.css

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

gzip:
	find out \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' -o -iname '*.png' -o -iname '*.jpg' \) \
		-exec gzip -9 -n {} \; \
		-exec mv {}.gz {} \;

## Cleans generated HTML and CSS
clean:
	mkdir -p out
	rm -rf out/*

## Prints this help
help:
	@grep -h -E '^#' -A 1 $(MAKEFILE_LIST) | grep -v "-" | \
	awk 'BEGIN{ doc_mode=0; doc=""; doc_h=""; FS="#" } { \
		if (""!=$$3) { doc_mode=2 } \
		if (match($$1, /^[%.a-zA-Z_-]+:/) && doc_mode==1) { sub(/:.*/, "", $$1); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$1, doc_h, doc; doc_mode=0; doc="" } \
		if (doc_mode==1) { $$1=""; doc=doc "\n" $$0 } \
		if (doc_mode==2) { doc_mode=1; doc_h=$$3 } }'
