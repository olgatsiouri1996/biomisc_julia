# julia
using FASTX
# main
print("convert the fasta file into a tablular format file\nusage: julia fasta_to_tab.jl input_fasta output_txt")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[2],"a") do io
for record in reader
    println(io,FASTA.identifier(record),"\t",FASTA.sequence(record))
end
close(reader)
end
