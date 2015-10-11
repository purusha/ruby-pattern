class MyEntity  
  def initialize(attributes)  
    attributes.each do |k,v|
      instance_variable_set("@#{k}",v)
      
      # if you want accessors:
      eigenclass = class<<self; self; end
      eigenclass.class_eval do
        attr_accessor k
      end
    end  
  end    
end

puts MyEntity.new({
  :a => "hello", :b => "world !!", :c => 42
}).inspect