#!/usr/local/bin/ruby

require 'date'
require_relative "logDate"

# The class LogLine is specifically to represent logfile lines as seen in 
# <i>psmetric01</i>. Here a few examples of log lines.
#  Oct 31 11:06:01 psana101 systemd: Stopping User Slice of nmingott.
#  Oct 31 14:22:43 psana101 sshd[4668]: Connection closed by 172.21.33.16 port 54600 [preauth]
#  
# We observe there are 4 elements of interest: the *time* the log arrived, the *hostname*
# of the machine who created the log, the *application* who created the log and finally the *message*. 
# This structure dependes on the servers configuration.
# 
# We streee an important point, <em>in the date there miss the year</em>. For this reason 
# we implement a few methods to return a date including the year.
# 
class LogLine
  # The variable contains the effective log line String, as red from the lofgile. 
  attr_accessor :line
  # Example:
  #  ll = LogLine.new( "Oct 31 11:06:01 psana101 systemd: Stopping User Slice of nmingott." )
  def initialize(str)
    fail "Error, expectin a String in input." unless str.is_a? String
    @line = str
  end
  # 
  # Return *String*, the date substring from the log line. Returns <b>""</b> 
  # if the date can't be found or is not valid.
  #    ll.getDateStr 
  #    => "Oct 31 11:06:01"
  def getDateStr
    return "" if @line.length < 15
    tmpStr = @line[0..14]
    begin
      DateTime.strptime(tmpStr, "%b %d %H:%M:%S")
      out = tmpStr
    rescue
      out = ""
    end
    return out 
  end
  # 
  # Returns a *Boolean*, *true* if the LogLine string contains a correct date substring
  # and false otherwise. 
  #    ll.hasDate?
  #    => true
  def hasDate?
    if self.getDateStr == "" then out = false else out = true end 
    return out
  end
  # 
  # Returns +String+. Date of the logline in format *LogDate*.
  def getLogDate()
    return self.getDateStr()
  end
  # 
  # Returns +String+. Date of the logline in format *FullLogDate*.
  def getFullLogDate()
    return self.getDateStr.to_FullLogDate()
  end
  # 
  # Returns +DateTime+. Date of the logline as a +DateTime+.
  def getDateTime()
    return self.getLogDate.to_DateTime()
  end
  # 
  # Parse the LogLine string and returns a Ruby +Hash+.
  # Return +Hash+. 
  # 
  # These keys are added to the onse found parsin the line
  # +parseFail+ : in general is +false+. If there were error parsing the line 
  # its value is set to +true+ and the whole line content is set under the key +message+.
  #               
  # The *dates* are converted to a format Elasticsearch can recognize. 
  # ie. "2018-11-10T22:48:01". When there is an error in parsing the 
  # date is set at the moment of paring the data.
  # 
  def parse
    out = {}
    begin 
      o = @line.match(/(.*?\d\d:\d\d:\d\d) (.*?) (.*?) (.*$)/ )
      out["date"] = o.captures[0].to_ElasticDate
      out["machine"] = o.captures[1]
      out["service"] = o.captures[2]
      m = out["service"].match(/\[(\d+)\]\:{0,1}/)
      if m then 
        out["servicePid"] = m.captures[0]
        out["serviceName"] = out["service"].sub(/\[\d+\]\:{0,1}/,"")
      elsif 
        out["servicePid"] = -1
        out["serviceName"] = out["service"].sub(/\:$/,"")
      end
      out["message"] = o.captures[3]
      out["parseFails"] = false
    rescue => ex
      STDERR.puts "--- Exception in parsing ----"
      STDERR.puts "#{@line}"
      out["date"] = DateTime.now().to_ElasticDate
      out["machine"] = ""
      out["service"] = ""
      out["serviceName"] = ""
      out["servicePid"] = ""
      out["message"] = @line
      out["parseFails"] = true
    end
    return out
  end
end

