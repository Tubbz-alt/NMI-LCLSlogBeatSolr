
require 'date'

# We overload the class +String+ with some methods to simplify the management of dates.
# 
# Dates appearing in LCLS logfiles have this format: <b>Oct 21 10:23:11</b> .
# We call such formatted strings +LogDate+. We do not definie a specific class for this kind of objects.
# The important thing here is that +LogDate+ do not contain the year.
#
# We say that a String in this format: <b>2018 Oct 21 10:23:11</b>, is a string in the +FullLogDate+ format.
# 
# The following methods permit to move fast between these kind of objects: 
# +LogDate+, +FullLogDate+ and +DateTime+. 
#
# When a conversion is needed between +LogDate+ and some other kind of date representation
# requiring the *year*, the the <b>year is guessed</b> with this rule. "We select the year such 
# that appending it before the +LogDate+ string, we get a valid +FullLogDate+ string representing 
# the nearest past date respect to present".
# 
# <b>See also</b>. companion methods overloading the +DateTime+ class.
class String
  # 
  # Returns Boolean. Checks if the +String+ is in the +LogDate+ format.
  #   "Nov 01 14:12:10".is_LogDate?
  #   => true
  #   "asdf".is_LogDate?
  #   => false
  def is_LogDate?
    begin
      DateTime.strptime(self, "%b %d %H:%M:%S")
      return true
    rescue
      return false
    end
  end
  #
  # Returns Boolean. Checks if a +String+ is in the +FullLogDate+ format.
  #   "2011 Nov 01 14:12:10".is_FullLogDate?
  #   => true
  #   "Nov 01 14:12:10".is_FullLogDate?
  #   => false
  def is_FullLogDate?
    begin
      DateTime.strptime(self, "%Y %b %d %H:%M:%S")
      return true
    rescue
      return false
    end
  end
  # 
  # Returns +DateTime+. Given a +LogDate+ or +FullLogDate+ format string, it 
  # returns a +DateTime+ object. In the case of +LogDate+ the year must be guessed.
  # See notes on the top. 
  # If the string is not in the +LogDate+ or +FullLogDate+ format then it raises
  # the +NoMethodError+. 
  #   "Nov 01 14:12:10".to_DateTime
  #   => #<DateTime: 2018-11-01T14:12:10+00:00 ((2458424j,51130s,0n),+0s,2299161j)>
  def to_DateTime
    if self.is_LogDate? 
      d0 = DateTime.strptime(self, "%b %d %H:%M:%S" )
      dNow = DateTime.now 
      yearNow = dNow.year 
      dGuess0 = DateTime.new(yearNow, d0.month, d0.day, d0.hour, d0.minute, d0.second)
      dGuess1 = DateTime.new(yearNow - 1, d0.month, d0.day, d0.hour, d0.minute, d0.second)
      if dGuess0 < dNow then out = dGuess0 else out = dGuess1 end 
      return out
    end
    if self.is_FullLogDate?
      d0 = DateTime.strptime(self, "%Y %b %d %H:%M:%S" )      
      return d0
    end
    # if we arrived here the string does not contain a date in a format 
    # we care about. so we raise an error. 
    raise NoMethodError
  end
  # 
  # Returns +String+. Given a string in the +LogDate+ or +FullLogDate+ format 
  # return a +String+ in the +FullLogDate+ format.
  #  "Nov 01 14:12:10".to_FullLogDate
  #  => "2018 Nov 01 14:12:10"
  def to_FullLogDate
    if self.is_LogDate? 
      d0 = self.to_DateTime
      return d0.strftime("%Y %b %d %H:%M:%S")
    end
    if self.is_FullLogDate?
      return self
    end
    # se siamo arrivati qui la stringa non e' nel formato di data da noi riconosciuto
    # quindi il metodo non e' valido. 
    raise NoMethodError
  end
  # 
  # Returns +String+. Given a string in the +LogDate+ of +FullLogDate+ format
  # returns a string in the +LogDate+ format. For all other strings raises
  # the +NoMethodError+.
  def to_LogDate 
    if self.is_LogDate? 
      return self
    end
    if self.is_FullLogDate?
      return self[5..19]
    end
    # if we arrived here something went wrong
    raise NoMethodError
  end
  # 
  # Returns +String+. Convert to a date format undertandable by Elasticsearch/Kibana.
  # i.e.: "2018-11-11T15:24:43"
  def to_ElasticDate
    return self.to_DateTime.to_ElasticDate
  end
end 


# We overload the class +DateTime+ with two methods to get the string 
# representation of the date object either in the +LogDate+ format or 
# in the +FullLogDate+ format.
# 
class DateTime 
  # 
  # Returns a +String+. The string is in the +LogDate+ format.
  #   d = DateTime.now
  #   => #<DateTime: 2018-11-02T19:36:40-07:00 ((2458426j,9400s,652004441n),-25200s,2299161j)>
  #   d.to_LogDate
  #   => "Nov 02 19:36:40"
  def to_LogDate
    return self.strftime("%b %d %H:%M:%S")
  end
  #
  # Returns a +String+. The string is in the +FullLogDate+ format.
  #   d = DateTime.now
  #   => #<DateTime: 2018-11-02T19:36:40-07:00 ((2458426j,9400s,652004441n),-25200s,2299161j)>
  #   d.to_FullLogDate
  #   => "2018 Nov 02 19:36:40"
  def to_FullLogDate
    return self.strftime("%Y %b %d %H:%M:%S")
  end
  # 
  # Return +String+. The string is in a format that Elasticsearch/Kibana 
  # can recognize as a date: "2018-11-11T15:24:43+TIMEZONE" .
  # NOTA: 'offset di timezone "%z" seguendo questa pagina per lo standard: goo.gl/oY9knv
  # 
  def to_ElasticDate
    return (self.strftime("%Y-%m-%dT%H:%M:%S") + DateTime.now.zone)
  end
end 
