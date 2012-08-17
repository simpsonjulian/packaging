Feature: Start Scripts

In order to use the product
As a user of server
I'd like the start scripts to be flexible

Scenario:  Different JVMs
  Given I have a JDK in /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/
  When I start neo4j in the /tmp/neo4j-community-1.8.M07/ directory
  Then I should see the path  /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/ in the process table
