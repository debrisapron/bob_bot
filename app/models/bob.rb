class Bob < User

  RULES = {
    [/^[^\p{Ll}]*$/, /\p{Lu}+/] => 'Woah, chill out!',
    [/\?$/]                 => 'Sure.',
    [/^\s*$/]               => 'Fine. Be that way!'
  }

  def self.respond_to(msg)
    matching_rules = RULES.select do |patts, resp|
      patts.all? { |patt| msg =~ patt }
    end

    # Silly dance to avoid if, unless and (just in case) iif
    matching_responses = (matching_rules.any? && matching_rules.values) || ['Whatever.']
    matching_responses.join(' ')
  end

  # There's only one bob
  def self.instance
    @bob ||= Bob.first
  end

  def self.id
    instance.id
  end

  def initialize(*args)
    # Only create a new Bob if there isn't already one
    fail("Initializing Bob failed because Bob already exists") if Bob.exists?
    super(id: 0)
  end

  def name
    'Bob'
  end

  def token
    nil
  end

end