#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'


# Class to abstract the comunication with *Elasticsearch*.  
#
class ElasticTalk
  attr_reader :host, :port 
  def initialize(host="localhost", port="9200")
    @host = host
    @port = port 
  end
  # 
  # Return +Object+. 
  # Equivalent to "ssh -L 9200:localhost:9200 p@elavi"
  # 
  # def ElasticTalk.openElaviTunnel
  #   out = "
  # end
  # 
  # Returns +Truth+ value. Il Elastic search is reachable returns +true+.
  # Otherwise +false+. Catches exceptions, always returns the truth value.
  # Roughly equivalent to this shell command. 
  #    $> curl 'http://#{@host}:#{@port}'
  def is_elasticReachable?
    uri = URI.parse("http://#{@host}:#{@port}")
    out = Net::HTTP.get_response(uri)
    if out.code.to_i == 200 
      return true
    else 
      STDERR.puts "Error reaching Elasticsearch: " + 
                  "#{out.header.code} -- #{out.header.message}"
      return false 
    end
    # questo ci pretegge da eventuali eccezioni. 
  rescue => ex 
    STDERR.puts ex
    return false
  end  
  # 
  # Return +String+. If there is an errore returns nil. 
  # TODO: Execeptions.
  # Gives a back a string giving some details on the Elastisearch 
  # server. 
  def getElasticDescription
    uri = URI.parse("http://#{@host}:#{@port}")
    out = Net::HTTP.get_response(uri)
    if out.code.to_i == 200 
      return out.body
    else 
      STDERR.puts "Error reachin Elasticsearch: " + 
                  "#{out.header.code} -- #{out.header.message}"
      return nil
    end    
  end
  # 
  # Return +...+. Insert a single document into Elasticsearch using POST.
  # With this method of insertion the document "ID" is auto-generated
  # by Elasticsearch.
  # Example
  #    jd = '{"date":"2018 Nov 10 20:00:00", "machine":"foo", 
  #           "service":"bar", "message":"hello world"}'
  #    ec.postLog("lclslogs-test", "log", )
  #         
  def postLogAsJSON(index="lclslogs-test", type="log", jsonStr, bulk: false)
    if bulk == true 
      uri = URI.parse("http://#{@host}:#{@port}/#{index}/#{type}/_bulk")
    else
      uri = URI.parse("http://#{@host}:#{@port}/#{index}/#{type}/")
    end
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = jsonStr
    res = http.request(req)
    # puts "response: #{res.body}"
    return res
  end
  # 
  # 
  # Example
  #   d = {date: "2018 Nov 10 22:48:00", machine: "foo", 
  #        service: "bar", message: "hello 2"} 
  #   et.postLogAsRubyHash(d)
  # 
  def postLogAsRubyHash(index="lclslogs-test", type="log", diz)
    postLogAsJSON(index, type, diz.to_json)
  end
  #
  # 
  # Sends a list of Ruby +Hash+ objects to Elasticsearch in bluk.
  # 
  # Returns: [sizeInByteOfThePayloadSend, responseObjectFromElasticSearch].
  # if +:fake+ is +true+ returns +nil+.
  #  
  # Conversion to JSON is automatic. Conversion to the BULK format for Elasticsearch is automatic.
  # 
  # If 'fake' is +true+ then the JSON payload is *not* sent to Elasticseach 
  # but printed to +STDOUT+.
  # 
  # Example
  #   d1 = {date: "2018 11 Nov 11:32:00", machine: "foo", service: "bar", message: "hello Sunday"}
  #   d2 = {date: "2018 11 Nov 11:33:00", machine: "foo", service: "bar", message: "hello Sunday 2"}
  #   d3 = {date: "2018 11 Nov 11:34:00", machine: "foo", service: "bar", message: "hello Sunday 3"}
  #   l = [d1, d2, d3]
  #   et.postLogBatch(l, fake: true)
  #   et.postLogBatch(l)       
  # 
  def postLogBatch(index="lclslogs-test", type="log", list, fake: false)
    # controlla che "list" sia un array
    unless list.is_a? Array 
      fail "Error, 'list' must be an array, it is: #{list}."      
    end
    # se la lista e' vuota esci
    return nil if list.length == 0
    # controlla che ogni elementi di 'list' sia un Hash
    unless list.all? {|x| x.is_a? Hash} 
      fail "Error, each element of 'list' must be an Hash."
    end
    # costruisce la stringa JSON da inviare
    outJ = ""
    list.each do |diz|
      tmp = %Q[ {"index":{}} \n ]
      tmp = tmp + diz.to_json 
      outJ = outJ + tmp + "\n"
    end
    if fake == true 
      # puts outJ[1..200] + "..." 
      return nil 
    else
      res = postLogAsJSON(index, type, outJ, bulk: true)      
      # outTmp = res.body[1..100].dup
      # res.clear
      return [list.length, outJ.size, res]
    end
  end
  
end 

