module Callbacks
  def self.included(base)
    base.extend(ClassMethods)
  end

  def self.extended(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    [:before, :after, :around].each do |cb_when|
      define_method("#{cb_when}_save_callbacks".to_sym) do
        self.instance_variable_get("@_#{cb_when}_saves")
      end
      define_method("#{cb_when}_save".to_sym) do |*args|
        send("add_#{cb_when}_save_callback".to_sym, *args)
      end
      define_method("add_#{cb_when}_save_callback".to_sym) do |*args|
        if prev = self.instance_variable_get("@_#{cb_when}_saves")
          self.instance_variable_set("@_#{cb_when}_saves", (prev << args))
        else
          self.instance_variable_set("@_#{cb_when}_saves", [args])
        end
      end
      private "add_#{cb_when}_save_callback".to_sym
    end
  end
end

class Test
  include Callbacks
  before_save :blah1
  after_save :blah2
  around_save :blah3


  def save
    run_before_save_callbacks
    _save
    run_after_save_callbacks
    run_around_save_callbacks
  end

  private

  def run_before_save_callbacks
    self.class.before_save_callbacks.each do |callback|
      self.send(callback.first.to_sym)
    end
  end

  def run_after_save_callbacks
    self.class.after_save_callbacks.each do |callback|
      self.send(callback.first.to_sym)
    end
  end

  def run_around_save_callbacks
    self.class.around_save_callbacks.each do |callback|
      self.send(callback.first.to_sym)
    end
  end

  def _save
    #this is where the actual save would happen
    puts "actual save happening"
  end

  def blah1
    puts " i'm in blah1 "
  end

  def blah2
    puts " i'm in blah2 "
  end

  def blah3
    puts " i'm in blah3 "
  end

  def update_all
  end

  def update_attributes
  end

  def destory
  end
end

Test.new.save