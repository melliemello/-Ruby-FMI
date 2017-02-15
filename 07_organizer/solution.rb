module LazyMode
  def self.create_file (file_name, &block)
    file = File.new(file_name)
    file.instance_eval(&block)
    file
  end

  class Date
    attr_reader :year, :month, :day

    def initialize (date)
      date_array = date.split('-')
      @year = date[0].to_i
      @month = date[1].to_i
      @day = date[2].to_i
    end

    def to_s
      "%04d-%02d-%02d" % [@year, @month, @day]
    end

    def add_days(days)
      @day += days % 30
      @month += (days / 30) if days / 30 > 0
      @year += (days / 365) if days / 365 > 0

      if (@day > 30 || @month > 12) then
        @day, @month = @day % 30, @month + @day / 30
        @month, @year = @month % 12 , @year + @month / 12
      end
    end
  end

  class Note
    ATTRIBUTES = [:header, :tags, :status, :body, :file_name, :date_pattern]

    def initialize (header, *tags, &block)
      @attributes = {}
      @attributes[:header] = header
      @attributes[:tags] = tags || []
      @attributes[:status] = :topostpone
    end

    def method_missing (name, *args)
      is_valid_setter = args.length > 0
      is_valid_getter = args.length == 0 && ATTRIBUTES.include?(name)
      return (@attributes[name] = args[0]) if is_valid_setter
      return @attributes[name] if is_valid_getter

      super
    end

    def scheduled (date_pattern)
      @attributes[:date_pattern] = date_pattern
    end
  end



  class AgendaRepeater
    include Enumerable

    def initialize (note)
      @start_date = Date.new(note.date_pattern.gsub(/(\+([0-9])+([w,m,d]){1})/, ''))
      @interval, @period  = 1, 'none'
      @note = note
      
      repetition_pattern = note.date_pattern.match(/\+([0-9])+([w,m,d]){1}/)
      @times, @period  = repetition_pattern.captures if repetition_pattern

      enum_for :each
    end

    def each
      time_intervals, date = {m: 30, d: 1, w: 7, none: 1}, @start_date.clone
      loop do
        date.add_days(@times.to_i * time_intervals[@period.to_sym])
        cloned_note = self.clone
        cloned_note
      end
    end

  end

  class File
    attr_reader :name, :notes

    def initialize (name)
      @notes = []
      @name = name
    end

    def note (header, *tags)
      note = Note.new(header, *tags)
      note.file_name @name
      note.instance_eval(&Proc.new)
      @notes << note
    end

    def daily_agenda (date)
      agenda = []
      @notes.each do |note|
        note_enumerator = AgendaRepeater.new(note)
        notes_for_date = note_enumerator.lazy.take(5).each do |entry|
          p entry
        end
        # p notes_for_date
      end
    end
  end


  # module Schedulable
  #   @date = null
  #   def date= (date)
  #     @date = Date.new(date)
  #   end

  #   def date
  #     @date
  #   end
  # end

end

file = LazyMode.create_file('work') do
        note 'sleep', :important, :wip do
          scheduled '2012-08-07'
          status :postponed
          body 'Try sleeping more at work'
        end


        note 'useless activity' do
          scheduled '2012-07-07'
        end
      end

file.daily_agenda(LazyMode::Date.new('2012-08-09'))
# p file.name                  # => 'work'
# p file.notes.size            # => 2
# p file.notes.first.file_name # => 'work'
# p file.notes.first.header    # => 'sleep'
# p file.notes.first.tags      # => [:important, :wip]
# p file.notes.first.status    # => :postponed
# p file.notes.first.body      # => 'Try sleeping more at work'
# p file.notes.last.file_name  # => 'work'
# p file.notes.last.header     # => 'useless activity'
# p file.notes.last.tags       # => []
# p file.notes.last.status     # => :topostpone




