# Advent of Code 2022

This repository is meant to showcase my solutions to https://adventofcode.com/2022 and also build related tooling.

For the first two days you can just go in a folder and for example run `ruby calory_counting.rb puzzle` (the argument being the name of a file containing your input).

For the remaining days I'll try use my tooling to scaffold my exercices :

```bash
bundle install
ruby init.rb 2 rock_paper_scissors
ruby day2/rock_paper_scissors.rb
# Or if you just want the current day puzzle with a script name taken from puzzle name :
ruby init.rb
```

If you want to use this you should also connect via browser to your AoC account and retrieve your cookie session and store it in a `.session_cookie` file (look at [init.rb](init.rb) to see how it is used).

Warning : the "example" file is found through a possibly flawed heuristic, that might not always be the real puzzle example so you need to double check.
