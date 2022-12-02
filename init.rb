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

  def download_example
    doc = Nokogiri::HTML(download_path)
    doc.search("code").map(&:text).sort_by(&:size).last
  end

  def download_puzzle
    download_path("input")
  end

  private

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

  argument :day
  argument :name

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_solver_file
    template("solver.rb.tt", "#{day}/#{name}.rb")
  end

  def create_puzzle_files
    day_number = day[3..].to_i
    downloader = AocDownloader.new(day_number)
    create_file("#{day}/example") { downloader.download_example }
    create_file("#{day}/puzzle") { downloader.download_puzzle }
  end
end

Init.start
