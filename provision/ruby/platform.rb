class UnknownPlatform

    def self.identify
        WindowsPlatform.maybe ||
            UnknownPlatform.new
    end

    def get_total_memory
        12288
    end

    def get_processors_count
        2
    end

end

class WindowsPlatform < UnknownPlatform

    def self.maybe
        RUBY_PLATFORM =~ /win32|mingw32/ ? WindowsPlatform.new : false
    end

    def get_total_memory
        `wmic os get TotalVisibleMemorySize | findstr "^[0-9]"`.to_i / 1024
    end

    def get_processors_count
        ENV['NUMBER_OF_PROCESSORS']
    end

end
