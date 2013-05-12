def with_tailcall_optimization
  if defined?(RubyVM)
    old_option = RubyVM::InstructionSequence.compile_option
    RubyVM::InstructionSequence.compile_option = {
      trace_instruction: false,
      tailcall_optimization: true
    }
  end
  begin
    yield
  ensure
    if defined?(RubyVM)
      RubyVM::InstructionSequence.compile_option = old_option
    end
  end
end

with_tailcall_optimization do
  require "radd_djur/grammar"
end
