class UnknownPlatform

    def self.identify
        if RUBY_PLATFORM =~ /win32|mingw32/
            Windows.new
        else
            UnknownPlatform.new
        end
    end

    def get_total_memory
        12288
    end

    def get_processors_count
        2
    end

end

class Windows < UnknownPlatform

    def get_total_memory
        `wmic os get TotalVisibleMemorySize | findstr "^[0-9]"`.to_i / 1024
    end

    def get_processors_count
        ENV['NUMBER_OF_PROCESSORS']
    end

end
