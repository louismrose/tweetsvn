class HashUtil
  def self.squash(hash, separator="_", prefix="")
    squashed = {}

    hash.each_pair do |key, value|
      if value.is_a?(Hash)
        squashed.merge! squash(value, separator, prefix + key + separator)
      else
        squashed[prefix + key] = value
      end
    end

    squashed
  end
end