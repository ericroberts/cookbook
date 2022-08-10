server: ruby -run -e httpd dist/ --port=4444
build: rerun 'ruby -Ilib build.rb' --pattern '**/*.{rb,slim,cook}'
css: npx tailwindcss -i ./src/input.css -o ./dist/styles.css --watch
js: npx webpack --watch
