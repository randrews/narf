require 'narf'

class Example
  def add a, b
    {:sum => a.to_f + b.to_f}
  end

  def echo a
    a
  end

  def wisdom
    "Wherever you go, there you are"
  end

  def frequency params
    str=params['string']
    freq={}
    str.split('').each do |c|
      freq[c] ||= 0
      freq[c] += 1
    end
    freq
  end
end

Narf.new(:port=>7000){
  expose :class=>Example
  expose :directory=>'files'
  expose :templates=>'templates', :as=>'/'
}.start
