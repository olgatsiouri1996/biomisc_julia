# julia
using FASTX
# main
print("usage: julia fasta_to_ids.jl input_fasta output_txt")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[2],"a") do io
for record in reader
    println(io,FASTA.identifier(record))
end
close(reader)
end
