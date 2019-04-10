module WARB
  class Function
    attr_reader :type, :locals, :blocks, :instructions

    def initialize(type)
      @type = type
      @locals = []
      @instructions = nil
      @blocks = nil
    end

    def set_code_from_io(io)
      size = io.read_u32
      pos = io.pos

      io.read_vector do
        @locals.concat(
          Array.new(
            io.read_u32,
            WARB::ValueType.from_byte(io.readbyte),
          )
        )
      end

      @instructions = WARB::ModuleIO.new(io.read(size - (io.pos - pos)))
      @blocks = WARB::ControlFlow::IndexedBlocks.from_function_body(self)
      @instructions.rewind
    end

    def inspect
      "#<#{self.class} locals:#{@locals.size} instr:#{@instructions.size}>"
    end
  end
end
