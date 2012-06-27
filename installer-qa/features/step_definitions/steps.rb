require 'rubygems'
require 'bundler'
require 'vagrant'
require 'fileutils'
require 'net/http'
include FileUtils


def index(vm)
  vm[5..6].to_i - 1
end

def command(command_line, machine)
  begin
    @env.cli("ssh", "-c", command_line, machine)
  rescue SystemExit
  end
end


Given /^I have a brand new (.*) VM$/ do |vm|
  @env = Vagrant::Environment.new(:ui_class => Vagrant::UI::Basic)
  @env.cli("destroy","-f", vm)
  @env.cli("up")
end

When /^I copy the tarball for the (.*) edition to the (.*) VM$/ do |edition, vm|
  index = index(vm)
  vm = @env.vms_ordered[index]
  puts vm.channel.upload("../standalone/target/neo4j-#{edition}-1.8-SNAPSHOT-unix.tar.gz","/home/vagrant/.")
end

When /^I untar the tarball for the (.*) edition on the (.*) VM$/ do |edition, vm|
  command("tar -xf neo4j-#{edition}-1.8-SNAPSHOT-unix.tar.gz", vm)
end

When /^I uncomment the '(.*)' option in the '(.*)' config file for the (.*) edition on the (.*) VM/ do |option, file, edition, vm|
  command = "sed -i 's/^##{option.sub('.','\.')}/#{option}/' neo4j-#{edition}-1.8-SNAPSHOT/conf/#{file}"
  command(command, vm)
end

When /^I (.*) the (.*) script for the (.*) edition on the (.*) VM/ do |action, script, edition, vm|

  command "./neo4j-#{edition}-1.8-SNAPSHOT/bin/#{script} #{action}", vm

end

Then /^I should see the webadmin page over HTTP for VM (.*)$/ do  |vm|

  sleep 10 # we need the webdriver wait method

  # this sickens me but I can't yet see how to do this via the API

  ip_address = File.read('Vagrantfile').each_line.select{|line| line =~ /network/ }[index(vm)].split(' ').last.gsub(/"/, '')
  Capybara.app_host = "http://#{ip_address}:7474"

  #url = "http://#{ip_address}:7474/webadmin"
  visit('/webadmin')
  page.should have_content 'Neo4j Monitoring and Management Tool'

end
