Given /^I have a JDK in (.*)/ do |java_location|
  File.exists?(java_location).should == true
end

When /^I start neo4j in the (.*) directory$/ do |neo_location|
  File.exists?(neo_location).should == true
  puts `(cd #{neo_location} && ./bin/neo4j start)`
  $?.exitstatus.should == 0
end

Then /^I should see the path (.*) in the process table$/ do |path|
  `ps -ewwf | grep neo4j-kernel`.should match(path)
end

