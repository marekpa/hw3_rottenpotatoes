# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #flunk "Unimplemented"
  assert (page.body.index(e1) < page.body.index(e2))
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if (uncheck != nil)
    #unchecks steps
    count = 1
    rating_list.split(%r{,\s*}).each do |ratx|
      if (count == 1)
         step %Q{I uncheck "ratings_#{ratx}"}
         count = 2
      else
         step %Q{I uncheck "ratings_#{ratx}"}
      end
    end
  else
  #check steps
    count = 1
    rating_list.split(%r{,\s*}).each do |ratx|
      if count == 1
         step %Q{I check "ratings_#{ratx}"}
         count = 2
      else
         step %Q{I check "ratings_#{ratx}"}
      end
    end
  end
end

Then /^I should see no movie$/ do
  movies = Movie.all
  movies.each do |movie|
    step %Q{I should not see "#{movie[:title]}"}
  end
end

Then /^I should see all of the movies$/ do
  movies = Movie.all
  movies.each do |movie|
    step %Q{I should see "#{movie[:title]}"}
  end
end

Then /^Movies should be sorted alphabetically$/ do
  movies = Movie.order("title")
  movies2 = movies.map do |x| x end
  movies.each do |x|
    movies2.slice!(0)
    movies2.each do |y|
        step %Q{I should see "#{x[:title]}" before "#{y[:title]}"}
    end
  end      
end

Then /^Movies should be sorted by release date$/ do
  movies = Movie.order("release_date")
  movies2 = movies.map do |x| x end
  movies.each do |x|
    movies2.slice!(0)
    movies2.each do |y|
        step %Q{I should see "#{x[:release_date]}" before "#{y[:release_date]}"}
    end
  end  
end

