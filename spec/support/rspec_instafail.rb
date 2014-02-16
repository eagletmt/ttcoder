module FixRSpecFail
  def _dump_pending_example(*)
    puts
    super
  end
end

RSpec::Instafail.send(:prepend, FixRSpecFail)
