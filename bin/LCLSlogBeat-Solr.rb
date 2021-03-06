#!/usr/bin/env jruby

# Migrating from Elasticsearch to Solr 

require "resolv"
require "json"
# require "pry"
require_relative "../lib/tailer"
require_relative "../lib/logWalker"
# require_relative "../lib/elasticTalk"
require_relative "../lib/solrTalk"
require_relative "../lib/logLine"

# require_relative "logDate"

# Open the file to log the data stream sent to Elasticsearch.
# Useful for debug purposes.
LOG = File.open("/var/log/LCLSlogBeat.log","a")

# oggetto ElastiTalk che serve per comunicare con Elasticsearch
# 172.21.32.95 --> psmetric04 
# ipv4Str =  Resolv.getaddress("psmetric04")
# et = ElasticTalk.new(ipv4Str, "9200")
# fail "Error, Elasticsearch is not reachable" if not et.is_elasticReachable?

ipv4Str =  Resolv.getaddress("psmetric04")
st = SolrTalk.new(ipv4Str, "8983")
fail "Error, Solr is not reachable" if not st.is_solrReachable?

# oggetto LogWalker che serve per trovare i logfiles 
lw = LogWalker.new("/u2/logs")

# *** Temporarily a brief one *** 
# lista di tutti i logfiles 

allLogFiles = lw.logFiles.to_a; nil 
# allLogFiles = [ "/u2/logs/psmetric01/messages", "/u2/logs/psmetric04/messages"  ] ; nil 

# binding.pry

# costruisce lista di tutti i tailable files 
# una "tailable" file e' un file su cui si puo' 
# chiamare il metodo "tail"
tailableFiles = []
allLogFiles.each do |path|
  unless File.stat(path).readable? then
    # If we send immediately a message to the logfile it will not
    # be seen by our system because the tailing has still to be started.
    # So we wait a bit, a few seconds, arbitrarily before throwing this message.
    # The thread is necessary to let the main flux of the program go on.
    Thread.new { 
      sleep 10
      errMsg = "Error, file not readable: '#{path}' "
      STDERR.puts errMsg 
      LOG.puts errMsg
    }
    next
  end
  tf = Tailer.new(path)
  tailableFiles.push(tf)
end; nil 


while true do 
  # lista that contains all Logs (in form of Ruby Hashes) to be sent
  # in batch to Elasticsearch
  rubyLineDizBuffer = []

  # elaborate each tailFile (that is all logFiles)
  tailableFiles.each do |tf|
    # parse each new line in a logfile and put it into a buffer called "rubyLineDizBuffer"
    tf.getLines.each do|line| 
      # to avoid problem with non UTF-8 charactres while parsing 
      # further problems may happen in "tail-file" looking for newlines.
      safeLine = line.encode!('UTF-8', :invalid => :replace)
      ll = LogLine.new(safeLine)
      rubyLineDiz = ll.parse
      # add a field containing all the log line, this simplifies searching
      rubyLineDiz["src"] = ll.line
      # add the filename, cause it is not included in loglines
      rubyLineDiz["file"] = File.basename(tf.f)
      rubyLineDizBuffer.push(rubyLineDiz)
    end
  end 
  # se non ci sono dati salta il resto, aspetta un po e rifai
  if rubyLineDizBuffer.length == 0 
    sleep 1
    next
  end
  
  # -] puts rubyLineDizBuffer
  # numLogs, batchBytes, res = et.postLogBatch(index="lclslogs", type="log", 
  #                                            rubyLineDizBuffer, fake: false)

  # errors = JSON.parse(res.body)['errors']
  # loggerLine =  "numLogs: #{numLogs}, batchBytes: #{batchBytes}, errors: #{errors}"

  # puts "-------------------------"
  # puts rubyLineDizBuffer
  # puts st.formatLogBatchAsXML(rubyLineDizBuffer)

  # -] puts rubyLineDizBuffer
  begin 
    numLogs, batchBytes, res = st.addLogsBatchXML(index="lclsLogs", rubyLineDizBuffer)
  rescue Exception => ex 
    puts ex
  else
    # print injection summary only if the script was started from a shell
    if STDOUT.isatty 
      # thusand separator added 
      numLogsStr = numLogs.to_s.reverse.gsub(/(\d{3})(?=\d)/,'\1,').reverse
      numBytesStr = batchBytes.to_s.reverse.gsub(/(\d{3})(?=\d)/,'\1,').reverse
      puts %Q{ BatchSummary: N.logs: #{numLogsStr}, N.bytes: #{numBytesStr}, status: #{res} \n}
    end
                                                                                        
  end




  # -] NEW ============================================

  # univmssDizListBuffer = []
  # # per permettere a Wilko di modificare il formato 
  # # dei dati senza bloccare tutta l'applicazione.
  # begin 
  #   rubyLineDizBuffer.each do |d|
  #     if d['service'].match /univmss/ then
  #       # puts d
  #       txt = d['message'].dup
  #       m = txt.match /\Atype (?<type>put|get)/
  #       if m[:type] == "put" then 
  #         fields = txt.split
  #         d['type'] = "put"
  #         d['elapms'] = fields[3].to_i
  #         d['size'] = fields[5].to_i
  #         d['rc'] = fields[7].to_i
  #         d['lfn'] = fields[8]
  #         d['tfb'] = fields[9]
  #         univmssDizListBuffer.push(d)
  #       elsif m[:type] == "get" 
  #         fields = txt.split
  #         # get fields
  #         d['type'] = "get"
  #         d['elapms'] = fields[3].to_i
  #         d['size'] = fields[5].to_i
  #         d['rc'] = fields[7].to_i
  #         d['lfn'] = fields[8]
  #         d['tfn'] = "nil"
  #         univmssDizListBuffer.push(d)        
  #       end
  #     else
  #       nil
  #     end    
  #   end
  # rescue Exception => ex 
  #   # in case of errors forget all work done, it may be all wrong.
  #   univmssDizListBuffer = []
  # end

  # if univmssDizListBuffer.length != 0 then 
  #   # puts univmssDizListBuffer
  #   numLogs, batchBytes, res = et.postLogBatch(index="univmss", type="univmssLog", 
  #                                              univmssDizListBuffer, fake: false)
  # end

  # ===========================================



  # -] force immediate writing of logline into the its logfile
  # LOG.puts loggerLine
  # LOG.flush

  # system("logger 'BatchToElastic: #{loggerLine}  '")
  # binding.pry

  sleep 1
end 

LOG.close
