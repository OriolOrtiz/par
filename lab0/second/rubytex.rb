def method_missing(m, *args, options: nil, special: false, &block)
  m = m.to_s

  return if m.start_with?("to_")

  if block_given?
    print "\\begin{#{m}}"
    print_options(options)
    print_args(args)

    puts

    yield

    puts "\\end{#{m}}"
  else
    print "\\#{m}"
    print '*' if special
    print_options(options)
    print_args(args)

    puts
  end
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
