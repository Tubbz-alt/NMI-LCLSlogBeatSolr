#!/reg/neh/home/nmingott/bin/jruby-9.1.17.0/bin/jruby

 
# class +TailFile+ define behaviour of a +TailFile+ object.
# A +TailFile+ 
# 
# Example 
#   tf = Tailer.new("/u2/logs/psmetric01/messages")
#   tf.getLines
#   tf.getLines
#
class Tailer 
  attr_reader :f, :path, :logfile
  # 
  # Example 
  # tf = TailFile.new("/u2/logs/psmetric01/messages")
  def initialize(path, logfile=STDERR)
    @f = File.open(path, "r")
    @path = path
    @logfile = logfile 
    # move to the end of file 
    f.seek(0, IO::SEEK_END)    
  end
  # 
  # get the new lines (tail lines) from the file 
  def getLines()
    # keep a copy of the original file, of something goes 
    # bad during adapting for rotation keep working on the old 
    # file descriptor @f.
    begin
      checkRotation()
    rescue Exception => ex       
      logfile.puts "Exception Rescued: Error in checking rotation, file: #{@path}."
      logfile.puts ex
      return []
    end
    out = []
    while true do
      line = @f.gets
      break if line.nil?
      out.push(line) 
    end
    return out
  end
  # 
  # This method checks if the file @f inode corresponds 
  # to the filename @path current inode. If the inodes are the same
  # it quits and does nothing. If the inodes do not correspond
  # then it means most probably the file has been rotated. So the 
  # file @f is redefined to refer to the new inode.
  private
  def checkRotation
    if @f.stat.ino == File.stat(@path).ino  then
      nil
    else 
     @logfile.puts "File #{@path} has been rotated. LCLSlogBeat, adapted."
     @f.close
     @f = File.open(@path,"r")
    end    
  end 
  #
  public 
  def close()
    @f.close
  end
end 


tf = Tailer.new("/u2/logs/psmetric01/messages")
tf.getLines
tf.getLines


# f = File.open("/u2/logs/psmetric01/messages","r")
# dump what has been red till now 
# out = f.read; nil 
# extra 
# f.eof?
# while (tmp = f.gets) do puts tmp; end 
# f.close


