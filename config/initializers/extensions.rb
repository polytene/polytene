class String
  def to_boolean
    !!(self =~ /^(true|t|yes|y|1)$/i)
  end

  def is_json?
    begin
      !!JSON.parse(self)
    rescue
      false
    end
  end

  def is_email?
    self.match(/\A\s*([-a-z0-9+._']{1,64})@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*\z/i)
  end
end
