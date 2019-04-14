module Marea::CoreExt
  module Scalar
    def p
      Pattern.pure(self)
    end
  end
end

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4')
  class Fixnum; include Marea::CoreExt::Scalar; end
else
  class Integer; include Marea::CoreExt::Scalar; end
end

class Float;    include Marea::CoreExt::Scalar; end
class String;   include Marea::CoreExt::Scalar; end
class Symbol;   include Marea::CoreExt::Scalar; end
class Rational; include Marea::CoreExt::Scalar; end
class Hash;     include Marea::CoreExt::Scalar; end
