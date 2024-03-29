require "active_support/all"
require "net/http"
require "nokogiri"

class AocHttpError < StandardError
  def initialize(response)
    super("Got HTTP status of #{response.code} for #{response.uri}")
  end
end

class AocDownloader
  AOC_ROOT = "https://adventofcode.com".freeze

  def initialize(year, day)
    source_folder = File.dirname(__FILE__)
    session_secret = File.read("#{source_folder}/.session_cookie")
    @url = URI(AOC_ROOT) + "#{year}/day/#{day}"
    @headers = { 'Cookie' => "session=#{session_secret}" }
  end

  def parse_puzzle_name
    puzzle_page.search("h2").first.text.split(":").last.tr("-", "").strip
  end

  def parse_example
    # Heuristic to find the example in the puzzle page
    example_intro = puzzle_page.search("p").find{ |para| para.text.starts_with?("For example") }
    if example_intro.present? && example_intro.next_element.child.name == "code"
      example_intro.next_element.text
    else
      puzzle_page.search("code").map(&:text).sort_by(&:size).last
    end
  end

  def parse_example_solution
    # Heuristic to find the example solution in the puzzle page
    part_one = puzzle_page.search("article").first
    part_one.search("code em").last.text
  end

  def download_puzzle
    download_path("input")
  end

  private

  def puzzle_page
    @puzzle_page ||= Nokogiri::HTML(download_path)
  end

  def download_path(path = nil)
    url = @url.dup
    url.path += "/#{path}" if path.present?
    response = Net::HTTP.get_response(url, @headers)
    raise AocHttpError, response unless response.code.starts_with?("2")

    response.body
  end
end

class Git
  include Singleton

  class << self
    def commit(msg)
      `git add . && git commit -m "#{msg}"`
    end
  end
end

class Solver
  def solve1
    raise NotImplementedError
  end

  def solve2
    raise NotImplementedError
  end

  def self.run
    if ARGV.present?
      ARGV.each do |arg|
        solver = new(arg, direct_input: true)
        puts "Solving for {#{arg}}: solution 1 is #{solver.solve1} and solution 2 is #{solver.solve2}"
      end
    else
      source_folder = File.dirname(self.instance_method("solve1").source_location.first)
      example_solver = new("#{source_folder}/example")
      puzzle_solver = new("#{source_folder}/puzzle")
      puts "Solving first part :"
      puts "=> example solution : #{example_solver.solve1}"
      puts "=> puzzle solution : #{puzzle_solver.solve1}"
      puts "Solving second part :"
      puts "=> example solution : #{example_solver.solve2}"
      puts "=> puzzle solution : #{puzzle_solver.solve2}"
    end
  end
end
