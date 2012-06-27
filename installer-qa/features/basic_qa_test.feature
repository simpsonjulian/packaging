Feature: Install Neo4j Tarball on Linux

  As someone who wants to install Neo4j
  I'd like it to reliable do what Neo says it does
  So I don't go and try another database

  Scenario Outline: Install Different Editions
    Given I have a brand new <vm> VM
    When I copy the tarball for the <edition> edition to the <vm> VM
    And I untar the tarball for the <edition> edition on the <vm> VM
    And I uncomment the 'org.neo4j.server.webserver.address' option in the 'neo4j-server.properties' config file for the <edition> edition on the <vm> VM
    And I start the neo4j script for the <edition> edition on the <vm> VM
    Then I should see the webadmin page over HTTP for VM <vm>

  Examples:
    | edition    |  vm      |
    | community  |  linux1  |
    | advanced   |  linux2  |
    | enterprise |  linux3  |