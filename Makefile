.PHONY: all

all:
	rm -rf dist
	bundle exec ruby -Ilib build.rb
	npx tailwindcss -i ./src/input.css -o ./dist/styles.css
	npx webpack
