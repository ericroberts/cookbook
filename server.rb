require "sinatra"

get "/js/recipe.js" do
  send_file "dist/js/recipe.js"
end

get "/styles.css" do
  send_file "dist/styles.css"
end

get "/" do
  send_file "dist/index.html"
end

get "/recipes/:name" do
  send_file "dist/recipes/#{params[:name]}/index.html"
end
