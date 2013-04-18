old_option = RubyVM::InstructionSequence.compile_option
RubyVM::InstructionSequence.compile_option = {
  trace_instruction: false,
  tailcall_optimization: true
}
begin
  require "haensel/grammar"
ensure
  RubyVM::InstructionSequence.compile_option = old_option
end
