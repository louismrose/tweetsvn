class Commit
  attr_reader :email, :text
  
  def initialize email
    @email = email
    @text  = email.body.raw_source
  end
end