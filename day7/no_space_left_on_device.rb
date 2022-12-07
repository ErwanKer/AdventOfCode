require "active_support/all"
require "tree"

class NoSpaceLeftOnDevice
  attr_accessor :input, :filesystem

  Cmd = Struct.new("Cmd", :name, :args, :res)
  Inode = Struct.new("Inode", :type, :dsize)

  def initialize(input_filename)
    @input = File.read(input_filename)
    generate_filesystem
  end

  def print_filesystem
    node_printer = lambda do |node, prefix|
      content = node.content.type == "dir" ? "dir" : "file, size=#{node.content.dsize}"
      puts "#{prefix} #{node.name} (#{content})"
    end
    filesystem.print_tree(filesystem.node_depth, nil, node_printer);
  end

  def solve1
    #print_filesystem
    filesystem.select do |node|
      node.children? && node.content.dsize <= 100_000
    end.map(&:content).map(&:dsize).sum
  end

  def solve2
    total_space = 7_000_0000
    unused_space = total_space - filesystem.content.dsize
    wanted_space = 3_000_0000 - unused_space
    filesystem.select do |node|
      node.children? && node.content.dsize >= wanted_space
    end.map(&:content).sort_by(&:dsize).first.dsize
  end

  def self.run
    source_folder = File.dirname(__FILE__)
    example_solver = new("#{source_folder}/example")
    puzzle_solver = new("#{source_folder}/puzzle")
    puts "Solving first part :"
    puts "=> example solution : #{example_solver.solve1}"
    puts "=> puzzle solution : #{puzzle_solver.solve1}"
    puts "Solving second part :"
    puts "=> example solution : #{example_solver.solve2}"
    puts "=> puzzle solution : #{puzzle_solver.solve2}"
  end

  private

  def parse_commands
    input.split("$ ").select(&:present?).map do |cmdline|
      head, *res = cmdline.split("\n")
      cmd, *args = head.split
      Cmd.new(cmd, args.join(" "), res)
    end
  end

  def generate_filesystem
    @filesystem = Tree::TreeNode.new("/", Inode.new("dir", 0))
    current_node = @filesystem
    parse_commands.each do |cmd|
      case cmd.name
      when "cd"
        current_node = case cmd.args
        when "/"
          filesystem
        when ".."
          current_node.parent
        else
          current_node[cmd.args]
        end
      when "ls"
        cmd.res.each do |inode_data|
          data, name = inode_data.split
          inode = if data.starts_with?("dir")
            Inode.new("dir", 0)
          else
            Inode.new("file", data.to_i)
          end
          current_node << Tree::TreeNode.new(name, inode)
          if inode.type == "file"
            current_node.content.dsize += inode.dsize
            current_node.parentage&.each { |node| node.content.dsize += inode.dsize }
          end
        end
      end
    end
  end
end

NoSpaceLeftOnDevice.run if __FILE__ == $0
