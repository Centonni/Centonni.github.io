module Jekyll
  class PostPublisher < Jekyll::Generator
    safe false

    def replace(filepath, regexp, *args, &block)
      content = File.read(filepath).gsub(regexp, *args, &block)
      File.open(filepath, 'wb') { |file| file.write(content) }
    end

    def generate(site)
      @files = Dir["_drafts/*"]
      @files.each_with_index { |f,i|
        nullable= checkPostStatus(f)
        if nullable
          now = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
          replace(f, /^status: published/mi) { |match| "date: \"" + now + "\"" }
          now = Date.today.strftime("%Y-%m-%d")
          File.rename(f, "_posts/#{now}-#{File.basename(f)}")
        end

      }
    end

    def checkPostStatus(filepath)
      return File.read(filepath).match(/^status: published/mi)
    end

  end
end
