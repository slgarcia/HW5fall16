Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end
 
 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  ratings = ["G","PG","PG-13","R"]
  ratingsStrings = arg1.split(%r{,\s*})
  ratings.each do |rating|
    if ratingsStrings.include? rating
      check("ratings_#{rating}")
    else
      uncheck("ratings_#{rating}")
    end
  end
  click_on "Refresh"
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  result = true
  ratings = arg1.split(%r{,\s*})
  all("tr/td[2]").each do |ratingTd|
    if !ratings.include? ratingTd.text
      result = false
    end
  end
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  result = all("tr/td[2]").count == Movie.all.count
  expect(result).to be_truthy
end

When /^I have opted to see movies in alphabetical order$/ do
   click_link("title_header")
end

Then /^I should see the title "(.*?)" before "(.*?)"$/ do |arg1, arg2|
  result = false
  #use each_cons here????
  all("tr/td[1]").each_cons(2) do |chunk|
    if (chunk[0].text+chunk[1].text).eql? arg1+arg2
      result = true
    end
  end
  expect(result).to be_truthy
end

When /^I have opted to see movies in increasing order by release date$/ do
  click_link("release_date_header")
end

Then /^I should see the release date "(.*?)" before "(.*?)"$/ do |arg1, arg2|
  result = false
  all("tr/td[3]").each_cons(2) do |chunk|
    if (chunk[0].text+chunk[1].text).eql? arg1+arg2
      result = true
    end
  end
  expect(result).to be_truthy
end