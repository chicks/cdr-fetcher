module CDR

require 'csv'
require 'rubygems'
require 'net/ssh'
require 'net/sftp'
  
class Fetcher
  attr :hostname, false
  attr :username, false
  attr :password, false
  attr :base_dir, false
  attr :last_dir, true
  attr :last_file, true
  
  # Fetch CDR's from a remote server.
  #
  # :base_dir defaults to "/var/log/asterisk/cdr-csv".
  # :last_dir defaults to the first sub-directory
  # in :base_dir.
  # :last_file defaults to the first file in :last_dir.
  # 
  # Usage:
  #
  #  require 'cdr'
  #  require 'pp'
  #  
  #  cdrs = CDR::Fetcher.new(
  #    'hostname', 
  #	   'username',
  #	   :password => 'password',
  #	   :base_dir => '/var/log/asterisk/cdr-csv',
  #	   :last_dir => 'old-cdrs',
  #	   :last_file=> 'old-cdr.csv')  
  #
  #  cdrs.each do |cdr|
  #    pp cdr
  #  end
  #
  def initialize(hostname, username, opts={})
    opts = { :password => nil,
             :base_dir => '/var/log/asterisk/cdr-csv',
             :last_dir => nil,
             :last_file=> nil
           }.merge!(opts)
    @hostname = hostname
    @username = username
    @password = opts[:password]
    @base_dir = opts[:base_dir]

    # Setup SSH and SFTP Connection
    @ssh      = Net::SSH.start(@hostname, @username, :password => @password)
    @sftp     = Net::SFTP::Session.new(@ssh).connect!

    # Grab the list of directories, and the current directory attributes
    @directories  = directories
    @cur_dir      = directory(opts[:last_dir]) 
    # If we weren't passed an argument, use the first file in the list
    @cur_dir    ||= @directories[0]
        
    # Grab the list of files from the current directory
    @files      = files
    @cur_file   = file(opts[:last_file])
    # If we weren't passed an argument, use the first file in the list
    @cur_file ||= @files[0]
  end
  
  # Iterator for Files.  Returns one file path at a time, automatically
  # moving to the next file or directory until all CDRs have been
  # returned.
  def each_file
    while true
      file = @cur_file
      if file
        yield [@base_dir,@cur_dir.name,@cur_file.name].join("/")
        next_file!
      else
        break
      end
    end        
  end
  
  # Iterator for CDRs.  Returns one CDR at a time, automatically
  # moving to the next file or directory until all CDRs have been
  # returned.
  #
  # CDR files are read into memory one at a time.
  def each
    each_file do |file|
      @sftp.download!(file).split(/\n/).each_with_index do |line,i|
        cdr = {
          :hostname => @hostname, 
          :file => file, 
          :line => i,
          :cdr  => CSV.parse_line(line)
          }
        yield cdr
      end
    end
  end
  
  protected

    # Set @cur_file to the next file.
    # Changes to next directory if all files in the current directory
    # have been read.
    def next_file!
      @files.each_with_index { |file,i|
        # find our current location
        if @cur_file == file
          next_file = @files[i+1]
          # If we dont hit the end of the array, everything is good.
          if next_file != nil
            @cur_file = next_file
            return @cur_file
          # if we hit the end of the array, we need to go to the next directory
          else
            # If we run out of directories, we need to exit properly.
            dir = next_dir!
            if dir
              return @cur_file
            else
              return false
            end
          end
        end
      }
    end
  
    # Set @cur_dir to the next directory.  
    # Updates @cur_file to the first file in that directory
    def next_dir!
      @directories.each_with_index {|dir,i|
        # find our current location
        if @cur_dir == dir
          next_dir = @directories[i+1]
          if next_dir != nil
            @cur_dir = next_dir
            @files   = files
            @cur_file = @files[0]
            return @cur_dir
          else
            return false
          end
        end
      }
    end
  
    # Return an Array of subdirectories in the @base_dir
    def directories
      directories = []
      @sftp.dir.foreach(@base_dir) do |entry|
        # skip parent, or hidden files/directories
        next if entry.name =~ /^\.+$/
        # skip files
        next unless entry.directory?
        # store everything else
        directories << entry
      end
      # Sort directories by modification time
      directories.sort! {|a,b| a.attributes.mtime <=> b.attributes.mtime}
      directories
    end
    
    # Searches for a directory entry by name
    # Returns a directory object from the list of directories
    def directory(dir_name)
      @directories.each do |dir|
        return dir if dir.name == dir_name
      end
      false
    end
    
    # Return a list of files in @cur_dir
    def files
      files = []
      @sftp.dir.foreach(@base_dir + "/" + @cur_dir.name) do |file|
        # ignore directories
        next unless file.file?
        files << file
      end
      # Sort each file by modification time
      files.sort! {|a,b| a.attributes.mtime <=> b.attributes.mtime }
      files
    end
    
    # Searches for a file entry by name
    # Returns a file object from the list of files
    def file(file_name)
      @files.each do |file|
        return file if file.name == file_name
      end
      false
    end
   
end

end


