module Callbacks
  def self.included(base)
    base.extend(ClassMethods)
  end

  def self.extended(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def before_save(*args)
      add_before_save_callback(*args)
    end

    def after_save(*args)
      add_after_save_callback(*args)
    end

    def around_save(*args)
      add_around_save_callback(*args)
    end

    def before_save_callbacks
      @_before_saves
    end

    def after_save_callbacks
      @_after_saves
    end

    def around_save_callbacks
      @_around_saves
    end
    private

    def add_before_save_callback(*args)
      (@_before_saves ||= []) << args
    end

    def add_after_save_callback(*args)
      (@_after_saves ||= []) << args
    end

    def add_around_save_callback(*args)
      (@_around_saves ||= []) << args
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