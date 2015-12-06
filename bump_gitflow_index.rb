#!/usr/bin/env ruby

# Run this script from inside a directory has has
# had gitflow initialized with the default settings
#
# Pass in either major, minor, or hotfix when calling
# this script to bump the respective section.
#
# e.g.
# latest tag = v1.00.01
# major  => git flow release start v2.00.00
# minor  => git flow release start v1.01.01
# hotfix => git flow hotfix start v1.00.02
# credit to u/garman for writing this

VERSION_INDEX = { major: 0, minor: 1, hotfix: 2 }
@release_type = (ARGV[0] || "").downcase.to_sym
@index = VERSION_INDEX[@release_type]

def increment(part)
  (part.to_i + 1).to_s
end

def increment_major(part)
  "#{part.to_s.gsub("v", "").to_i + 1}"
end

def major_bump?
  @release_type == :major
end

def format_major(tag)
  "#{tag.split(".")[0]}.0.0"
end

def format_minor(tag)
  parts = tag.split(".")
  "#{parts[0]}.#{parts[1]}.0"
end

def create_branch_and_tag(tag)
  case @release_type
  when :hotfix
    puts "New tag: #{tag}"
    "git flow hotfix start v#{tag}"
  when :minor
    puts "New tag: #{format_minor(tag)}"
    "git flow release start v#{format_minor(tag)}"
  when :major
    puts "New tag: #{format_major(tag)}"
    "git flow release start v#{format_major(tag)}"
  end
end

def index_to_bump?(map_index)
  map_index == @index
end

def bump_tag(part)
  major_bump? ? increment_major(part) : increment(part)
end

def bump_version(part, map_index)
  index_to_bump?(map_index) ? bump_tag(part) : part
end

# Credit to u/dayer4b for a better tag fetching command
def bump
  parts = `git tag -l | sort -V | tail -n1 | sed -e 's/v//g'`.split('.')
  print "Current tag: #{parts.join(".")}"
  puts
  formatted = parts.map.with_index do |e, i|
    bump_version(e, i)
  end
  exec create_branch_and_tag(formatted.join("."))
end

if VERSION_INDEX.keys.include?(@release_type)
  bump
else
  puts "major, minor, hotfix only"
end
