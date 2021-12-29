.PHONY: all assets

all:
	ruby -Ilib build.rb
	npx tailwindcss -i ./src/input.css -o ./dist/styles.css
	npx webpack
