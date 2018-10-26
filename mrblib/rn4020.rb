#
# PlatoDevice::RN4020 class
#
module PlatoDevice
  class RN4020 < Plato::BLE
    include Plato::Machine

    MAX_RETRY = 3
    SERV_UUID = "38e432eabeb911e7abc4cec278b6b50a"
    CHAR_UUID = "38e437d6beb911e7abc4cec278b6b50a"

    CMDLIST = {
      'SF' => '1',              # Initialize
      'S-' => 'RN4020',         # Device name
      'SR' => '20006000',       # System function
      'ST' => '0010,0002,0064', # Connection parameter
      'SS' => '40000000'        # Server service (Battery)
    }

    def initialize(name)
      @ser = Serial.open(115200)
      CMDLIST['S-'] = name
      start
    end

    def start
      CMDLIST.each {|k, v|
        k = [k, v].join(',') if v
        cmd(k)
      }
      cmd('R,1', 'CMD') # Reset
    end

    def battery=(lvl)
      cmd 'SUW,2A19,' + format('%02x', lvl)
    end

    def start_custom_service(datasize)
      CMDLIST['SS'] = '00000001' # Service service (Private service)
      CMDLIST['PZ'] = nil        # Clear private service
      CMDLIST['PS'] = SERV_UUID  # Private service UUID
      CMDLIST['PC'] = CHAR_UUID + ',12,' + format('%02x', datasize)  # Private characteristic UUID
      start
    end

    def chardata=(v)
      s = v.to_s
      ss = s.chars.inject('') {|sv, c|
        sv += c.ord.to_s(16)
      }
      cmd 'SUW,' + CHAR_UUID + ',' + ss
    end

    def self.open(name='Plato', datasize=30)
      bt = self.new(name)
      bt.start_custom_service(datasize)
      bt
    end

    def puts(v)
      self.chardata = v
    end

    # private

    # Send command to RN4020
    def cmd(c, term="AOK")
      rcv = []
      MAX_RETRY.times {
        puts ">>#{c}" if $DEBUG
        @ser.puts c
        loop {
          rsp = @ser.gets
          unless rsp.empty?
            rsp.chomp!
            rcv << rsp
            puts "<<#{rsp}" if $DEBUG
            return rcv if rsp == term
            break if rsp == 'ERR'   # Error -> retry
          end
          Machine.delay(10)
        }
      }
      raise "RN4020 command error " + c
    end
  end
end
