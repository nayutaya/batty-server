
class String
  def %(args)
    if args.kind_of?(Hash)
      ret = dup
      ret.gsub!(PERCENT_MATCH_RE) {|match|
        if match == '%%'
          '%'
        elsif $1
          key = $1.to_sym
          args.has_key?(key) ? args[key] : match
        elsif $2
          key = $2.to_sym
          args.has_key?(key) ? sprintf("%#{$3}", args[key]) : match
        end
      }
      ret
    else
      ret = gsub(/%([{<])/, '%%\1')
      begin
        ret._old_format_m(args)
      rescue ArgumentError => e
        if $DEBUG
          $stderr.puts "  The string:#{ret}"
          $stderr.puts "  args:#{args.inspect}"
          puts e.backtrace
        else
          raise ArgumentError, e.message
        end
      end
    end
  end
end

