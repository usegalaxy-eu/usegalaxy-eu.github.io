#!/usr/bin/env ruby
require 'yaml'
fn = ARGV[0]

# Required keys
post_required_keys = ['site', 'tags', 'title', 'location']
event_required_keys = ['site', 'tags', 'starts', 'ends', 'organiser', 'location']

# Any error messages
errs = []

# Handle tutorials
if fn.include?('_posts') then
  data = YAML.load_file(fn)

  # Check for required keys
  post_required_keys.each{ |x|
    if not data.key?(x) then
      errs.push("Missing key: #{x}")
    end
  }
elsif fn.include?('_events') then
  data = YAML.load_file(fn)

  # Check for required keys
  event_required_keys.each{ |x|
    if not data.key?(x) then
      errs.push("Missing key: #{x}")
    end
  }

  # Check formatting of organiser
  if not data.key?('organiser') then
    errs.push("Empty organiser name #{data['organiser']}")
  else
    if not data['organiser'].key?('name') or data['organiser']['name'].nil? or data['organiser']['name'].length == 0 then
      errs.push("Empty organiser name")
    end

    if not data['organiser'].key?('email') or data['organiser']['email'].nil? or data['organiser']['email'].length == 0 then
      errs.push("Empty organiser email")
    end
  end



else
  puts "No validation available for filetype"
  exit 0
end


# If we had no errors, validated successfully
if errs.length == 0 then
  puts "#{fn} validated succesfully"
  exit 0
else
  # Otherwise, print errors and exit non-zero
  puts "#{fn} has errors"
  errs.each {|x| puts "  #{x}" }
  exit 1
end
