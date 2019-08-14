#!/usr/bin/env ruby
#
# Created Nov Aug 14, 2019 by Scott Kensell
#
# This script takes a Pull Request number and outputs the files
# organized by teams specified in CODEOWNERS.
#
# To use:
#
#   1. Setup a Personal Access Token on Github following instructions here:
#     https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/
#
#   2. Store the access token in an environment variable called GITHUB_ACCESS_TOKEN
#   2.5 Replace MY_COMPANY below to match corp endpoint.
#
#   3. Install Github's Ruby toolkit: `gem install octokit`. See https://github.com/octokit/octokit.rb
#
#   4. Run from the command line:
#     code_owners_for_pr.rb <PR-NUMBER>
#
#   5. Smile. (If you frown, slack Scott.)
#
# Caveats:
# Github's API unfortunately maxes out at 300 files so this isn't as useful as it could be for mega PRs.
#

require 'octokit'

Octokit.configure do |c|
  c.api_endpoint = "https://github.corp.MY_COMPANY.com/api/v3/"
  c.auto_paginate = true
end

class Team

  attr_reader :name
  attr_reader :owned_files

  def initialize(name)
    @name = name
    @owned_files = []
  end

  def add_owned_file(file)
    # ensures we add it sorted
    index = 0
    f = @owned_files[index]
    while f && f.filename < file.filename
      index += 1
      f = @owned_files[index]
    end
    @owned_files.insert(index, file)
  end

  def to_s
    if @owned_files.count == 0
      return "#{@name}\n\t(No owned files)"
    end
    return "#{@name}\n\t" + @owned_files.map { |f| f.filename }.join("\n\t")
  end

end

class PathComponentNode

  attr_accessor :name
  attr_accessor :children
  attr_accessor :owning_team

  def initialize(name)
    @name = name
    @children = []
  end

end

class CodeOwners

  attr_accessor :teams # array of Team objects
  attr_accessor :owned_code_tree # the root PathComponentNode

  def initialize()
    @teams = []
    @owned_code_tree = PathComponentNode.new("")
    @teams_by_name = {}
  end

  def team_by_name(team_name)
    @teams_by_name[team_name]
  end

  def add_team_if_needed(team_name)
    team = @teams_by_name[team_name]
    if !team
      team = Team.new(team_name)
      @teams.push(team)
      @teams_by_name[team_name] = team
    end
    return team
  end

  def team_owning_filename(filename)
    path_components = filename.split("/").select {|x| x != ""}
    return team_owning_filename_internal(@owned_code_tree, path_components)
  end

  private
  def team_owning_filename_internal(node, remaining_segments, team_owning_dir=nil)
    if remaining_segments.count == 0
      # should only happen when codeowners claims a specific file as opposed to directory
      return node.owning_team
    end

    if node.children.count == 0
      # matched (bc all leaf nodes should have owning_teams)
      return node.owning_team
    end

    segment = remaining_segments.delete_at(0)
    matching_node = node.children.find { |n| n.name == segment  }

    team_owning_dir = node.owning_team || team_owning_dir

    if !matching_node
      # having a match means someone has claimed a codepath which has a common prefix
      # no match means that the common prefix has ended and now we should look upwards to see which is the first
      # team which has claimed ownership
      return team_owning_dir
    end

    return team_owning_filename_internal(matching_node, remaining_segments, team_owning_dir)
  end

end


def get_teams_for_pr(pull_request_number, personal_access_token)
  client = Octokit::Client.new(:access_token => personal_access_token)
  files = client.pull_request_files('MY_COMPANY/MY_REPO', pull_request_number)

  if files.count == 300
    puts "WARNING: Too many files! Github API only gives us a maximum of 300 files and this PR contains more than 300."
  end

  affected_teams = []
  code_owners = create_code_owners()

  files.each do |file|
    team = code_owners.team_owning_filename(file.filename)
    if team
      team.add_owned_file(file)
    end
  end

  return code_owners.teams.select { |team| team.owned_files.count > 0 }
end

# reads the CODEOWNERS file and outputs a structured CodeOwners object
def create_code_owners
  paths_and_team_names = parse_file_into_n_by_2_array()

  code_owners = CodeOwners.new()
  rootNode = code_owners.owned_code_tree
  teams_by_name = {}

  paths_and_team_names.each do |path, team_name|

    path_components = path.split("/").select {|x| x != ""}
    team = code_owners.add_team_if_needed(team_name)

    insertPathComponentNodes(rootNode, path_components, team)
  end

  return code_owners
end

def insertPathComponentNodes(current_node, remaining_segments, team_object)
  # inserts nodes until we hit leaf, then assigns team to leaf
  #
  # if remaining_segments is empty, then the code path matched an existing team, set owning_team to team_object
  # if current_node has a child which matches the first remaining_segment then recurse on that node with segments - 1
  # if current_node has no children which match, then we should create a new node for each remaining segment and assign team_object to final node

  if remaining_segments.count == 0
    # current_node represents last path segment, assign team
    current_node.owning_team = team_object
    return
  end

  segment = remaining_segments.delete_at(0)

  matching_node = current_node.children.find { |node| node.name == segment  }

  if matching_node
    insertPathComponentNodes(matching_node, remaining_segments, team_object)
    return
  end

  # insert segment and recurse
  node = PathComponentNode.new(segment)
  current_node.children.push(node)
  insertPathComponentNodes(node, remaining_segments, team_object)
end

def parse_file_into_n_by_2_array
  result = []

  File.readlines('.github/CODEOWNERS').each do |line|

    next if !line.start_with?("/")

    elt = line.split()[0..1]
    if elt.count == 2 && elt[1].start_with?("@")
      result.push(elt)
    end

  end

  return result
end

# runs this code only when we are the file being executed
# this allows this file to be used safely as a library too
if __FILE__ == $0
  personal_access_token = ENV["GITHUB_ACCESS_TOKEN"]
  pr_number = ARGV[0]
  teams = get_teams_for_pr(pr_number, personal_access_token)
  teams.each do |team|
    puts(team)
    puts "\n"
  end
end


