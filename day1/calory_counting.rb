cal_list = File.read(ARGV[0]).split("\n")

elf_list = [0]
cal_list.each do |cal_line|
  if cal_line == ""
    elf_list << 0
  else
    elf_list[-1] += cal_line.to_i
  end
end

max_elf = elf_list.each_with_index.max[1] + 1
res = elf_list.max
p res

max3 = elf_list.sort[-3..].sum
p max3
