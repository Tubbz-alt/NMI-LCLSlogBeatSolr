#!/usr/local/bin/ruby

require 'find'


# The class +LogWalker+ abstracts the most common access
# procedures to visit the log files. 
# 
# The class is tailored over +psmetric01+ case where 
# a single directory contains many machines logs. 
# 
class LogWalker 
  # Return +String+. Return the base node path under wich all 
  # log files are contained.
  attr_reader :basePath
  #
  # It is supposed the logfiles live under a common directory node. 
  # Here +path+ is a +String+ and must be the full path name of such
  # directory.
  #   sto = LogWalker.new("/mnt/lcls-logs")
  #    => #<LogWalker:0x00000008062a1418 @basePath="/mnt/lcls-logs">
  #    sto.basePath
  #    => "/mnt/lcls-logs"
  def initialize(path) 
    # toglie l'ultimo "/" da path se presente
    tmp = path.sub /\/$/, "" 
    fail "Error, '#{path}' is not a directory." unless File.directory? tmp
    fail "Error, '#{path}' directory is empty." if Dir.glob(tmp + "/*").length == 0
    @basePath = tmp
  end
  # 
  # Return +Enumerator+. The returned enumerator goes through all *files*  
  # contained below +basePath+ node. Directories are not files so they are 
  # not listed. 
  #   sto.allFiles
  #   => #<Enumerator: ...>
  #   sto.allFiles.each { |x| puts x; }  
  #   => ["/mnt/lcls-logs/psana101/crond.log",
  #      "/mnt/lcls-logs/psana101/crond.log-20180304.gz",
  #       "/mnt/lcls-logs/psana101/crond.log-20180311.gz",
  #       .... ]
  #   sto.allFiles.first(2)
  #   => ["/mnt/lcls-logs/psana101/crond.log",
  #       "/mnt/lcls-logs/psana101/crond.log-20180304.gz"]
  def allFiles
    if block_given? 
      all = Find.find( @basePath ) 
      while true 
        begin 
          tmp = all.next
        rescue StopIteration 
          break 
        end
        yield tmp if File.file? tmp
      end
    else 
      self.to_enum(:allFiles)
    end
  end
  # 
  # Return +Enumerator+. Return all files that can be considere log files. 
  # In our setup, these are all files who do *not* contain a *date* in the pathname.
  #   sto.logFiles
  #   => #<Enumerator: ...>
  #   sto.logFiles.first(3)
  #   => ["/mnt/lcls-logs/psana101/crond.log",
  #   "/mnt/lcls-logs/psana101/dbus-daemon.log",
  #   "/mnt/lcls-logs/psana101/dbus.log"]
  def logFiles
    if block_given? 
      all = Find.find( @basePath ) 
      while true 
        begin 
          # prendi il prossimo elemento trovato da Find.
          tmp = all.next
          # salta l'elemento se non e' un file 
          next unless File.file? tmp 
          # salta l'elemento se ha una data nel path e.g. "crond.log-20180304.gz"
          next if tmp.match /-\d{8}/ 
        rescue StopIteration 
          break 
        end
        yield tmp 
      end
    else 
      self.to_enum(:logFiles)
    end
  end  
  # 
  # Return +Enumerator+. Return all log files that have been rotated exactly one time.
  # There files in out setup are all the one that have a date but are not compressed.
  # 
  # It is useful to be able to spot these files because when a log file is empty  
  # we will look at the last logline in the rot1 file. The rot1 file can not be empty
  # by construction. Indeed, according to our current +logrotate.conf+ in +psmetric01+,
  # files are rotated only 
  # if they contain at least 100k, therefore the rotated file can not be empty.
  # 
  #   sto.rot1Files
  #   => #<Enumerator: ...>
  #   sto.rot1Files.first(3)
  #   => ["/mnt/lcls-logs/psana101/messages-20181028",
  #       "/mnt/lcls-logs/psana101/secure-20181028"]
  def rot1Files
    if block_given? 
      all = Find.find( @basePath ) 
      while true 
        begin 
          # prendi il prossimo elemento trovato da Find.
          tmp = all.next
          # salta l'elemento se non e' un file 
          next unless File.file? tmp 
          # salta l'elemento se NON ha una data nel path e.g. "crond.log"
          next unless tmp.match /-\d{8}/ 
          # salta l'elemento se termina con ".gz"
          next if tmp.match /\.gz$/
        rescue StopIteration 
          break 
        end
        yield tmp 
      end
    else 
      self.to_enum(:rot1Files)
    end
  end  
  # 
  # Return +Enumerator+. Return all files that can be considered compressed log files.
  # Those are files that have been rotated more than once. In our setup they are 
  # all files wich have a date in the pathname and are compressed, their pathname
  # end with ".gz".
  #  sto.rotCompressedFiles
  #  => #<Enumerator: ...>
  #  sto.rotCompressedFiles.first(3)
  #  => ["/mnt/lcls-logs/psana101/crond.log-20180304.gz",
  #  "/mnt/lcls-logs/psana101/crond.log-20180311.gz",
  #  "/mnt/lcls-logs/psana101/crond.log-20180319.gz"]
  def rotCompressedFiles
    if block_given? 
      all = Find.find( @basePath ) 
      while true 
        begin 
          # prendi il prossimo elemento trovato da Find.
          tmp = all.next
          # salta l'elemento se non e' un file 
          next unless File.file? tmp 
          # salta l'elemento se NON ha una data nel path e.g. "crond.log"
          next unless tmp.match /-\d{8}/ 
          # salta l'elemento se NON termina con ".gz"
          next unless  tmp.match /\.gz$/
        rescue StopIteration 
          break 
        end
        yield tmp 
      end
    else 
      self.to_enum(:rotCompressedFiles)
    end
  end  
  # 
end 


