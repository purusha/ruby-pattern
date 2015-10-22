s= "hi man"
p s.length #=> 6
p s.include? "hi" #=> true


p s.send(:length) #=> 6
p s.send(:include?,"hi") #=> true


method_object = s.method(:length) 
p method_object.call #=> 6
method_object = s.method(:include?)
p method_object.call('hi')  #=> true


eval "s.length" #=> 6
eval "s.include? 'hi'" #=>true


require "benchmark" 
test = "hi man" 
m = test.method(:length) 
n = 100000 
Benchmark.bmbm {|x| 
  x.report("call") { n.times { m.call } } 
  x.report("send") { n.times { test.send(:length) } } 
  x.report("eval") { n.times { eval "test.length" } } 
} 
#######################################
#####   The results
#######################################
#Rehearsal ----------------------------------------
#call   0.050000   0.020000   0.070000 (  0.077915)
#send   0.080000   0.000000   0.080000 (  0.086071)
#eval   0.360000   0.040000   0.400000 (  0.405647)
#------------------------------- total: 0.550000sec 
#          user     system      total        real
#call   0.050000   0.020000   0.070000 (  0.072041)
#send   0.070000   0.000000   0.070000 (  0.077674)
#eval   0.370000   0.020000   0.390000 (  0.399442)


class Foo
  private  
  def hi 
    puts "hi man" 
  end 
end
 
# Normal method calling
f = Foo.new  #=> <Foo:0x10a0d51>
f.hi  #=>NoMethodError: private method `hi' called for #<Foo:0x10a0d51> 
 
# Sending a message
f.send :hi #  hi man
 
# Instantiating a method object
f.method(:hi).call  # hi man
 
# Using eval
eval "f.hi"  #=>NoMethodError: private method `hi' called for #<Foo:0x10a0d51> 
 
# Using instance_eval
f.instance_eval {hi}  # hi man


see http://blog.khd.me/ruby/ruby-dynamic-method-calling/ and related page (link at bottom of article)
