class String
  def to_a()
    self.split(',')
  end
end

class Array
  def to_a()
    self
  end
end

def method_missing(m, *args, options: nil, special: false, &block)
  m = m.to_s

  return if m.start_with?("to_")

  if block_given?
    env(m, *args, options: options) { yield }
  else
    print "\\#{m}"
    print '*' if special
    print_options(options)
    print_args(args)

    puts
  end
end

def env(name, *args, options: nil)
  print "\\begin{#{name}}"
  print_options(options)
  print_args(args)

  puts

  yield

  puts "\\end{#{name}}"
end

def print_options(options)
    print "[#{options.to_a.join(",")}]" unless options.nil?
end

def print_args(args)
    args.each {|arg| print "{#{arg}}"} if args
end

def escape(s)
  s.gsub('_', '\\_')
end

def p(*args)
  puts *args
end

def wrap()
    print "{"
    yield
    puts "}"
end

def br(size=nil, units: "cm")
    print "\\\\"
    print "[#{size}#{units}]" unless size.nil?
    puts
end

def head(*args)
  row *args.map{|arg| "\\textbf{#{arg}}"}
end

def row(*args)
  hline
  puts escape args.join(' & ')
  br
end

def figure(options: "h!")
  env("figure", options: options) { yield }
end

def graphic(path, options: "width=1.0\\textwidth")
  includegraphics path, options: options
end

$problem_counter = 0
def question(text)
  setcounter "enumi", $problem_counter
  $problem_counter += 1
  item; bold text
end

def answer()
  br
  yield
end

# Commands
def blueline(line); textcolor "blue", line; end
def hrule(); rule "\\linewidth", "0.5mm"; end
def bold(text); textbf text; end
def math(); puts "\\["; yield; puts "\\]"; end
def equals(); puts "="; end
