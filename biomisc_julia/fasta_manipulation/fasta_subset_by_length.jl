# julia
using FASTX
# main
print("collect proteins with user specified length \nusage: julia fasta_collect_putative_effectome.jl input_fasta min_length max_length output_fasta")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[4],"a") do io
for record in reader
    if parse(Int, ARGS[2]) < length(FASTA.sequence(record)) < parse(Int, ARGS[3])
        println(io,record)
    end
end
close(reader)
end
