require "objspace"
ObjectSpace.trace_object_allocations_start
puts "Profiling is enabled"

Signal.trap("TTOU") do
  puts "Profiling"
  GC.start
  ObjectSpace.dump_all(output: File.open("tmp/heap.json", "w"))
  puts "Dump is done"

  `
  cat tmp/heap.json |
    ruby -rjson -ne ' obj = JSON.parse($_).values_at("file","line","type"); puts obj.join(":") if obj.first ' |
    sort      |
    uniq -c   |
    sort -n   |
    tail -20 > report
  `
  puts "Report is generated"
end
