#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'digest'
require 'date' 

# Class to abstract the comunication with *Solr*.  
#
class SolrTalk
  attr_reader :host, :port 
  def initialize(host="localhost", port="8983")
    @host = host
    @port = port 
  end
  # 
  # Returns +Truth+ value. Il Solr search is reachable returns +true+.
  # Otherwise +false+. Catches exceptions, always returns the truth value.
  # Roughly equivalent to this shell command. 
  #    $> curl 'http://#{@host}:#{@port}/admin/cores'
  def is_solrReachable?
    uri = URI.parse("http://#{@host}:#{@port}/solr/admin/cores")
    out = Net::HTTP.get_response(uri)
    if out.code.to_i == 200 
      return true
    else 
      STDERR.puts "Error reaching Solr: " + 
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
  # Gives a back a string giving some details on the Solr 
  # server. 
  def getSolrDescription
    uri = URI.parse("http://#{@host}:#{@port}/solr/admin/cores")
    out = Net::HTTP.get_response(uri)
    if out.code.to_i == 200 
      return out.body
    else 
      STDERR.puts "Error reaching Solr: " + 
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
  # 
  # 
  # list: is a list of dictionaries describing each log. 
  # 
  # <add>
  # <doc>  
  # <field name="id">12346</field>
  # <field name="date">2019-11-07T06:33:00Z</field>	
  # <field name="title">test - Nicola Mingotti</field>
  # <field name="body"> Swiki 2020 restyling</field>			
  # </doc>
  # <doc> 
  # <field name="..."> </field> 
  # <field name="..."> .... 
  # </doc> 
  # </add>.
  # 
  def formatLogBatchAsXML(list)
    timeMillis = DateTime.now.strftime('%Q')
    outStr = %Q{<add>\n}
    # outStr = %Q{<add commitWithin="200">\n}
    # outStr = %Q{<add commit="true" softCommit="true">\n}
    idx = 0
    list.each do |diz|
      idx = idx + 1
      outStr = outStr + "<doc>\n"
      outStr = outStr + %Q{<field name="id">#{timeMillis}-#{idx}</field>\n}
      # we don't want to send all the fields, only a selection.
      ['date', 'machine', 'serviceName', 
       'servicePid', 'parseFails','src'].each do |k|        
        datTmp = diz[k].to_s.strip
        # ATTENTION: of course the next trasformation must be the first one.
        datTmp.gsub! "&", '&amp;'
        datTmp.gsub! '<', '&lt;'
        datTmp.gsub! '>', '&gt;'
        datTmp.gsub! '"', '&quot;'
        datTmp.gsub! "'", '&apos;' 
        tmp = %Q[<field name="#{k}">#{datTmp}</field>\n] 
        outStr = outStr + tmp 
      end
      outStr = outStr + "</doc>\n"
    end
    outStr = outStr + "</add>"
    return outStr
  end
  # 
  # Insert a list of logs into Solr, they are sent as XML data.
  # dizList: list of dictionaries describing the parsed loglines 
  def addLogsBatchXML(collection="lclsLogs", dizList, bulk: false)
    uri = URI.parse("http://#{@host}:#{@port}/solr/#{collection}/update")    
    # uri = URI.parse("http://psmetric04:8983/solr/lclsLogs/update")    
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/xml')
    req.body = formatLogBatchAsXML(dizList)
    # puts req.body 
    # res = http.request(req, xml: formatLogBatchAsXML(dizList) )
    res = http.request(req)
    # puts "response: #{res.body}"
    return [dizList.length, req.body.size, res]
  end
  # 
  # Example XML to add 2 documents 
  # 
  # 
  # def postLogBatchAsXML(catalog,list)
  #   # controlla che "list" sia un array
  #   unless list.is_a? Array 
  #     fail "Error, 'list' must be an array, it is: #{list}."      
  #   end
  #   # se la lista e' vuota esci
  #   return nil if list.length == 0
  #   # controlla che ogni elementi di 'list' sia un Hash
  #   unless list.all? {|x| x.is_a? Hash} 
  #     fail "Error, each element of 'list' must be an Hash."
  #   end
  #   # costruisce la stringa JSON da inviare
  #   outJ = ""
  #   list.each do |diz|
  #     tmp = %Q[ {"index":{}} \n ]
  #     tmp = tmp + diz.to_json 
  #     outJ = outJ + tmp + "\n"
  #   end
  #   if fake == true 
  #     # puts outJ[1..200] + "..." 
  #     return nil 
  #   else
  #     res = postLogAsJSON(index, type, outJ, bulk: true)      
  #     # outTmp = res.body[1..100].dup
  #     # res.clear
  #     return [list.length, outJ.size, res]
  #   end
  # end
  # 
  # end
  
end 

