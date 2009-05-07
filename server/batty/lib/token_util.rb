
module TokenUtil
  def self.create_token(size)
    return size.times.map { rand(16).to_s(16) }.join
  end

  def self.create_unique_token(klass, column, size)
    begin
      token = self.create_token(size)
    end while klass.exists?(column => token)

    return token
  end

  def self.create_token_regexp(size)
    return /\A[0-9a-f]{#{size}}\z/
  end
end
