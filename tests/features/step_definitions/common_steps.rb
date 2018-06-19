# Routing items --------------------------------------
Given(/^I am on the login page$/) do
  visit "http://localhost/#/auth/login"
end

Given(/^I am on the signup page$/) do
  visit "http://localhost/#/auth/register"
end

Given(/^I am on the dashboard page$/) do
  visit "http://localhost/#/pages/dashboard"
end
# ----------------------------------------------------

# Functions ------------------------------------------
And (/^I wait for (\d+) seconds?$/) do |n|
    sleep(n.to_i)
end

And (/^I click on text "(.*?)"$/) do |findtext|
    find('.clickable-text', :text => findtext).click
end

Then(/^I should see "(.*?)" text$/) do |text|
    expect(page).to have_content(text, wait: 20)
end

And(/^I press "([^\"]*)"$/) do |button|
    click_button(button)
end

And(/^I type "(.*?)" in "(.*?)" field$/) do |text,field|
    fill_in field, with: text
end

And(/^I scroll down$/) do
    page.execute_script "window.scrollBy(0,10000)"
end

And(/^I click on CSS class "(.*?)"$/) do |cssclass|
    find('.'+cssclass).click
end
# ----------------------------------------------------
