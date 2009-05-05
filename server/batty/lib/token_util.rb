

module TokenUtil

  def self.create_token(size)
    size.times.map{ rand(16).to_s(16) }.join
  end

  def self.create_unique_token(klass, column, size)
    begin
      token = create_token(size)
    end while klass.exists?(column => token)
    token
  end

  def self.create_token_regexp(size)
    /\A[0-9a-f]{#{size}}\z/
  end

end
