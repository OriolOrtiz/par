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

def document(title, subtitle, subject, authors, footer)
  env "document" do
    titlepage do
      center do
        textsc "\\Large #{subject}"; br
        texttt subtitle; br 1.5
        hrule; br 0.4
        wrap { huge; bfseries; puts title; br 0.4 }
        hrule; br 2.5

        minipage "0.4\\textwidth" do
          flushleft { large; puts authors[0] }
        end

        minipage "0.4\\textwidth" do
          flushright { large; puts authors[1] }
        end

        vfill
        wrap { large; today }
        br
        wrap { large; texttt footer }
      end
    end

    yield
  end
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
def question(text, counter: nil)
  $problem_counter = counter-1 unless counter.nil?
  setcounter "enumi", $problem_counter
  item; bold text
  $problem_counter += 1
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
