require "active_support/all"
require "net/http"
require "nokogiri"
require "thor/group"

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

  def puzzle_name
    puzzle_page.search("h2").first.text.split(":").last.tr("-", "").strip
  end

  def download_example
    puzzle_page.search("code").map(&:text).sort_by(&:size).last
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

  argument :day, type: :numeric, required: false, desc: "Number of the day in the month of the puzzle you want"
  argument :filename, type: :string, required: false, desc: "Snakecase version of the name you want, we will create filename.rb"

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.dirname(__FILE__)
  end

  def setup
    self.day = Date.current.day if day.nil?
    self.filename = downloader.puzzle_name.tr(" ", "_").underscore if filename.nil?
  end

  def create_solver_file
    template("solver.rb.tt", "day#{day}/#{filename}.rb")
  end

  def create_puzzle_files
    create_file("day#{day}/example") { downloader.download_example }
    create_file("day#{day}/puzzle") { downloader.download_puzzle }
  end

  private

  def downloader
    @downloader ||= AocDownloader.new(day)
  end
end

Init.start
