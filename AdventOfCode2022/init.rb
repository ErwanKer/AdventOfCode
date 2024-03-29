require "active_support/all"
require "net/http"
require "nokogiri"
require "thor/group"
require "byebug"

class AocHttpError < StandardError
  def initialize(response)
    super("Got HTTP status of #{response.code} for #{response.uri}")
  end
end

class AocDownloader
  AOC_ROOT = "https://adventofcode.com".freeze
  YEAR = 2022

  def initialize(day)
    source_folder = File.dirname(__FILE__)
    session_secret = File.read("#{source_folder}/.session_cookie")
    @url = URI(AOC_ROOT) + "#{YEAR}/day/#{day}"
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

class Init < Thor::Group
  include Thor::Actions

  desc <<~DOC
    This INIT tool is meant to be used as follows :
    ruby init.rb 4 my_solution # will create day4 folder with my_solution.rb and puzzle inputs
    ruby init.rb 4 # will create day4 folder and use puzzle name for the filename
    ruby init.rb # will download current day puzzle and use puzzle name for the filename
  DOC

  argument :day_num, type: :numeric, required: false, desc: "Number of the day in the month of the puzzle you want"
  argument :filename, type: :string, required: false, desc: "Snakecase version of the name you want, we will create filename.rb"
  attr_accessor :example, :example_solution, :day_name

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.dirname(__FILE__)
  end

  def setup
    self.day_num = Date.current.day if day_num.nil?
    self.day_name = "day%02d" % day_num
    self.filename = downloader.parse_puzzle_name.tr(" ", "_").underscore if filename.nil?
    self.example = downloader.parse_example
    self.example_solution = downloader.parse_example_solution
  end

  def create_solver_files
    template("solver.rb.tt", "#{day_name}/#{filename}.rb")
    template("solver_spec.rb.tt", "#{day_name}/#{filename}_spec.rb")
  end

  def create_puzzle_files
    create_file("#{day_name}/example") { example }
    create_file("#{day_name}/puzzle") { downloader.download_puzzle }
  end

  private

  def downloader
    @downloader ||= AocDownloader.new(day_num)
  end
end

Init.start
