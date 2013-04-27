# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.

    # This is the same approach that rate db:seed uses, supply a hash with column names and values
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk "Unimplemented"
  
  p1 = page.body.index(e1)
  p2 = page.body.index(e2)

  assert(p1, "Didn't find '#{e1}'")
  assert(p2, "Didn't find '#{e2}'")

  assert(p1 < p2, "Incorrect sequence (found '#{e1}' at position #{p1} and '#{e2}' at position #{p2})")
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.delete(" ").split(",").each do |rating|
    if uncheck
      step %{I uncheck "ratings_#{rating}"}
    else
      step %{I check "ratings_#{rating}"}
    end
  end
end


# Check that all movies are displayed

Then /I should see all of the movies/ do
  #  Ensure that the number of tables rows matches the database row count

  # Lookup info on the Copybara Server class for info on page methods
  if !page.has_table?("movies")
    flunk "No movies table found on the page"
  end

  c1 = page.all("table#movies tr").count
  c2 = Movie.all.length

  if c1 < c2
    flunk "Not all movies displayed (found '#{c1}', expected #{c2}"
  end 
end

# Check that a movie has the correct director

Then /the director of "(.*)" should be "(.*)"/ do |movie,director|
  p1 = page.body.index(movie)
  p2 = page.body.index(director)

  assert(p1, "Didn't find movie '#{movie}'")
  assert(p2, "Didn't find director'#{director}'")
end
