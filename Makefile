.PHONY: all

all:
	bundle exec ruby -Ilib build.rb
	npx tailwindcss -i ./src/input.css -o ./dist/styles.css
	npx webpack
